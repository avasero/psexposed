// Edge Function: update-public-indicators
// Sincroniza indicadores YAML com a tabela public_indicators no Supabase

import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";
import * as yaml from "https://esm.sh/js-yaml@4.1.0";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
};

interface YamlIndicator {
  name?: string;
  description?: string;
  regex?: string | string[];
  basescore?: number | string;
  max_match?: number | string;
  tactic?: string | string[];
  technique?: string | string[];
  reference?: string | string[];
}

interface IndicatorPayload {
  file_path: string;
  content?: string;
  link?: string;
  last_modified_by?: string;
  last_modified_by_avatar?: string;
  action: "upsert" | "delete";
}

interface RequestPayload {
  indicators: IndicatorPayload[];
  github_actor?: string;
}

interface DatabaseIndicator {
  name: string;
  description: string | null;
  patterns: string[];
  basescore: number;
  severity: string;
  tactics: string[];
  techniques: string[];
  reference: string[] | null;
  max_match: number;
  is_active: boolean;
  file_path: string;
  link?: string;
  last_modified_by?: string;
  last_modified_by_avatar?: string;
  is_premium_indicator: boolean;
}

/**
 * Calcula a severidade baseada no basescore
 */
function calculateSeverity(basescore: number): string {
  if (basescore >= 9.0) return "critical";
  if (basescore >= 7.0) return "high";
  if (basescore >= 5.0) return "medium";
  return "low";
}

/**
 * Converte valor para array de strings
 */
function toStringArray(value: unknown): string[] {
  if (!value) return [];
  if (typeof value === "string") return [value];
  if (Array.isArray(value)) {
    return value.map((v) => String(v)).filter((v) => v.length > 0);
  }
  return [];
}

/**
 * Filtra padrões regex válidos (remove URLs e strings vazias)
 */
function filterValidPatterns(patterns: string[]): string[] {
  return patterns.filter((pattern) => {
    if (!pattern || pattern.trim().length === 0) return false;
    // URLs geralmente começam com http:// ou https://
    if (pattern.startsWith("http://") || pattern.startsWith("https://"))
      return false;
    return true;
  });
}

/**
 * Faz o parse do conteúdo YAML e retorna um indicador formatado para o banco
 * Retorna um objeto com sucesso ou erro detalhado
 */
function parseYamlContent(
  content: string,
  filePath: string,
  link?: string,
  lastModifiedBy?: string,
  lastModifiedByAvatar?: string
): { indicator: DatabaseIndicator | null; error?: string } {
  try {
    console.log(`🔄 Iniciando parse de: ${filePath}`);
    const yamlData = yaml.load(content) as YamlIndicator;

    if (!yamlData) {
      const error = `YAML vazio ou inválido: ${filePath}`;
      console.log(`❌ ${error}`);
      return { indicator: null, error };
    }

    // Campos obrigatórios
    const name = yamlData.name?.trim();
    if (!name) {
      const error = `Campo 'name' obrigatório não encontrado: ${filePath}`;
      console.log(`❌ ${error}`);
      return { indicator: null, error };
    }

    // Processar description
    const description = yamlData.description?.trim() || null;

    // Processar patterns (regex)
    let patterns = toStringArray(yamlData.regex);
    patterns = filterValidPatterns(patterns);

    if (patterns.length === 0) {
      console.log(
        `⚠️ Nenhum padrão regex válido em ${filePath}, usando padrão default`
      );
      patterns = [".*"];
    }

    console.log(`🔍 Padrões extraídos para ${name}: ${JSON.stringify(patterns)}`);

    // Processar basescore
    let basescore = 5.0;
    if (yamlData.basescore !== undefined) {
      const parsed =
        typeof yamlData.basescore === "string"
          ? parseFloat(yamlData.basescore)
          : yamlData.basescore;

      if (!isNaN(parsed)) {
        // Limitar ao range válido (DECIMAL 3,1 = máximo 99.9)
        basescore = Math.max(0, Math.min(99.9, parsed));
      }
    }

    // Calcular severity
    const severity = calculateSeverity(basescore);

    // Processar tactics
    const tactics = toStringArray(yamlData.tactic);

    // Processar techniques
    const techniques = toStringArray(yamlData.technique);

    // Processar references
    const reference = toStringArray(yamlData.reference);

    // Processar max_match
    let maxMatch = 3; // Valor padrão da tabela
    if (yamlData.max_match !== undefined) {
      const parsed =
        typeof yamlData.max_match === "string"
          ? parseInt(yamlData.max_match, 10)
          : yamlData.max_match;

      if (!isNaN(parsed) && parsed >= 1) {
        maxMatch = Math.floor(parsed);
      }
    }

    console.log(`🎯 Max_match configurado para ${name}: ${maxMatch}`);

    const indicator: DatabaseIndicator = {
      name,
      description,
      patterns,
      basescore: parseFloat(basescore.toFixed(1)),
      severity,
      tactics,
      techniques,
      reference: reference.length > 0 ? reference : null,
      max_match: maxMatch,
      is_active: true,
      file_path: filePath,
      is_premium_indicator: false,
    };

    // Adicionar campos opcionais
    if (link) {
      indicator.link = link;
    }
    if (lastModifiedBy) {
      indicator.last_modified_by = lastModifiedBy;
    }
    if (lastModifiedByAvatar) {
      indicator.last_modified_by_avatar = lastModifiedByAvatar;
    }

    return { indicator };
  } catch (error) {
    const errorDetail = `Erro ao fazer parse do YAML ${filePath}: ${error.message}`;
    console.log(`❌ ${errorDetail}`);
    console.log(`📄 Conteúdo do YAML (primeiros 500 chars): ${content.substring(0, 500)}`);
    return { indicator: null, error: errorDetail };
  }
}

/**
 * Insere ou atualiza um indicador no banco de dados
 */
async function upsertIndicator(
  supabase: ReturnType<typeof createClient>,
  indicator: DatabaseIndicator
): Promise<{ success: boolean; error?: string; isNew?: boolean }> {
  try {
    // Verificar se já existe pelo file_path
    const { data: existing, error: selectError } = await supabase
      .from("public_indicators")
      .select("id, name")
      .eq("file_path", indicator.file_path)
      .single();

    if (selectError && selectError.code !== "PGRST116") {
      throw selectError;
    }

    if (existing) {
      // Atualizar indicador existente
      const { error: updateError } = await supabase
        .from("public_indicators")
        .update({
          name: indicator.name,
          description: indicator.description,
          patterns: indicator.patterns,
          basescore: indicator.basescore,
          severity: indicator.severity,
          tactics: indicator.tactics,
          techniques: indicator.techniques,
          reference: indicator.reference,
          max_match: indicator.max_match,
          link: indicator.link,
          last_modified_by: indicator.last_modified_by,
          last_modified_by_avatar: indicator.last_modified_by_avatar,
          updated_at: new Date().toISOString(),
        })
        .eq("id", existing.id);

      if (updateError) throw updateError;

      const nameChanged = existing.name !== indicator.name;
      console.log(
        `✅ Atualizado: ${indicator.name} (${indicator.file_path})${
          nameChanged ? ` [nome alterado de "${existing.name}"]` : ""
        }`
      );

      return { success: true, isNew: false };
    } else {
      // Inserir novo indicador
      const { error: insertError } = await supabase
        .from("public_indicators")
        .insert({
          ...indicator,
          created_at: new Date().toISOString(),
          updated_at: new Date().toISOString(),
        });

      if (insertError) throw insertError;

      console.log(`✅ Inserido: ${indicator.name} (${indicator.file_path})`);
      return { success: true, isNew: true };
    }
  } catch (error) {
    const errorMsg = `Erro ao processar ${indicator.name} (${indicator.file_path}): ${error.message}`;
    console.log(`❌ ${errorMsg}`);
    return { success: false, error: errorMsg };
  }
}

/**
 * Remove um indicador do banco de dados pelo file_path
 */
async function deleteIndicator(
  supabase: ReturnType<typeof createClient>,
  filePath: string
): Promise<{ success: boolean; error?: string }> {
  try {
    // Verificar se existe
    const { data: existing, error: selectError } = await supabase
      .from("public_indicators")
      .select("id, name")
      .eq("file_path", filePath)
      .single();

    if (selectError) {
      if (selectError.code === "PGRST116") {
        console.log(`⚠️ Indicador não encontrado para deleção: ${filePath}`);
        return { success: true }; // Não é um erro se já não existe
      }
      throw selectError;
    }

    // Deletar
    const { error: deleteError } = await supabase
      .from("public_indicators")
      .delete()
      .eq("id", existing.id);

    if (deleteError) throw deleteError;

    console.log(`🗑️ Deletado: ${existing.name} (${filePath})`);
    return { success: true };
  } catch (error) {
    const errorMsg = `Erro ao deletar ${filePath}: ${error.message}`;
    console.log(`❌ ${errorMsg}`);
    return { success: false, error: errorMsg };
  }
}

serve(async (req) => {
  // Handle CORS preflight
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  if (req.method !== "POST") {
    return new Response(JSON.stringify({ error: "Method not allowed" }), {
      status: 405,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  }

  try {
    console.log("🚀 Iniciando atualização da tabela public_indicators...");

    // Conectar ao Supabase
    const supabaseUrl = Deno.env.get("SUPABASE_URL");
    const supabaseServiceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");

    if (!supabaseUrl || !supabaseServiceKey) {
      throw new Error("Configuração do Supabase não encontrada");
    }

    const supabase = createClient(supabaseUrl, supabaseServiceKey);
    console.log("✅ Conectado ao Supabase");

    // Parse do request body
    const payload: RequestPayload = await req.json();

    if (!payload.indicators || !Array.isArray(payload.indicators)) {
      return new Response(
        JSON.stringify({
          error: "Campo 'indicators' não fornecido ou formato inválido",
          success: false,
        }),
        {
          status: 400,
          headers: { ...corsHeaders, "Content-Type": "application/json" },
        }
      );
    }

    console.log(`📊 Processando ${payload.indicators.length} indicadores...`);

    const errors: string[] = [];
    let processedCount = 0;
    let insertedCount = 0;
    let updatedCount = 0;
    let deletedCount = 0;

    for (const item of payload.indicators) {
      if (item.action === "delete") {
        // Processar deleção
        const result = await deleteIndicator(supabase, item.file_path);
        if (result.success) {
          deletedCount++;
        } else if (result.error) {
          errors.push(result.error);
        }
      } else if (item.action === "upsert" && item.content) {
        // Parse do YAML e upsert
        const parseResult = parseYamlContent(
          item.content,
          item.file_path,
          item.link,
          item.last_modified_by,
          item.last_modified_by_avatar
        );

        if (parseResult.indicator) {
          const result = await upsertIndicator(supabase, parseResult.indicator);
          if (result.success) {
            processedCount++;
            if (result.isNew) {
              insertedCount++;
            } else {
              updatedCount++;
            }
          } else if (result.error) {
            errors.push(result.error);
          }
        } else {
          errors.push(parseResult.error || `Falha ao fazer parse do YAML: ${item.file_path}`);
        }
      } else {
        console.log(`⚠️ Ação inválida ou conteúdo ausente: ${item.file_path}`);
      }
    }

    const response = {
      success: true,
      message: `Banco de dados atualizado! ${processedCount} processados, ${deletedCount} deletados.`,
      indicators_processed: processedCount,
      indicators_inserted: insertedCount,
      indicators_updated: updatedCount,
      indicators_deleted: deletedCount,
      total_received: payload.indicators.length,
      errors: errors.length > 0 ? errors : undefined,
    };

    console.log(`✅ ${response.message}`);

    return new Response(JSON.stringify(response), {
      status: 200,
      headers: { ...corsHeaders, "Content-Type": "application/json" },
    });
  } catch (error) {
    console.error("❌ Erro:", error.message);
    return new Response(
      JSON.stringify({
        error: error.message,
        success: false,
      }),
      {
        status: 500,
        headers: { ...corsHeaders, "Content-Type": "application/json" },
      }
    );
  }
});
