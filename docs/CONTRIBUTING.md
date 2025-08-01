# Contribuindo para PowerShell Community Signatures

Obrigado por contribuir! Este documento fornece diretrizes para contribuições efetivas.

## 🎯 Tipos de Contribuições

### 1. Novas Assinaturas
- Adicione assinaturas para detectar novos padrões maliciosos
- Documente completamente cada assinatura
- Inclua exemplos reais (anonimizados)

### 2. Melhorias em Assinaturas Existentes
- Reduza falsos positivos
- Melhore a precisão da detecção
- Atualize documentação

### 3. Correções de Bugs
- Corrija regex patterns incorretos
- Ajuste classificações de severidade
- Resolva falsos positivos

## 📝 Formato de Assinatura

Cada assinatura deve seguir este formato:

```powershell
<#
.SYNOPSIS
    Nome descritivo e conciso

.DESCRIPTION
    Descrição detalhada do que a assinatura detecta
    Inclua contexto sobre por que é importante

.SEVERITY
    critical|high|medium|low

.CATEGORY
    credential-theft|persistence|lateral-movement|ransomware|
    obfuscation|download-execute|privilege-escalation|other

.SCORE
    1-100 (pontuação de risco)

.REGEX
    Pattern regex para detecção

.FLAGS
    i|g|m|s (flags do regex)

.EXAMPLES
    Exemplo 1 de comando detectado
    Exemplo 2 de comando detectado
#>

# Comentários adicionais e exemplos de uso
```

## 🔍 Diretrizes de Regex

### ✅ Boas Práticas:
- Use padrões específicos e precisos
- Evite regex muito genéricas
- Teste com exemplos reais
- Considere diferentes variações

### ❌ Evite:
- Patterns que causam muitos falsos positivos
- Regex excessivamente complexas
- Padrões que detectam comandos legítimos comuns

## 📊 Classificação de Severidade

### Critical (90-100 pontos)
- Comandos claramente maliciosos
- Atividade de malware conhecido
- Exploits ativos

### High (70-89 pontos)
- Técnicas comumente usadas por atacantes
- Comandos suspeitos com alto potencial de abuso
- Ferramentas de hacking conhecidas

### Medium (40-69 pontos)
- Comandos potencialmente suspeitos
- Técnicas que podem ter uso legítimo
- Atividades que requerem investigação

### Low (1-39 pontos)
- Comandos raramente maliciosos
- Indicadores fracos
- Padrões de interesse baixo

## 🧪 Processo de Teste

### 1. Teste Local
```powershell
# Validar formato
.\scripts\validate.ps1 -Path .\signatures\

# Testar detecção
.\scripts\test-signatures.ps1 -SignaturePath .\signatures\
```

### 2. Verificação de Falsos Positivos
- Teste com comandos PowerShell legítimos comuns
- Verifique scripts administrativos típicos
- Considere automação empresarial

### 3. Teste de Eficácia
- Use exemplos de malware real (anonimizados)
- Teste variações do comando
- Verifique diferentes técnicas de ofuscação

## 📁 Organização de Arquivos

### Estrutura de Diretórios:
```
signatures/
├── malicious/
│   ├── credential-theft/    # Roubo de credenciais
│   ├── persistence/         # Persistência no sistema
│   ├── lateral-movement/    # Movimento lateral
│   └── ransomware/          # Atividades de ransomware
└── suspicious/
    ├── obfuscation/         # Técnicas de ofuscação
    ├── download-execute/    # Download e execução
    └── privilege-escalation/ # Escalação de privilégios
```

### Nomenclatura de Arquivos:
- Use nomes descritivos: `get-credential.ps1`
- Evite espaços: use hífens ou underscores
- Seja específico: `mimikatz-sekurlsa.ps1` vs `passwords.ps1`

## 🔄 Processo de Pull Request

### 1. Preparação
- Fork o repositório
- Crie uma branch descritiva
- Faça commits atômicos

### 2. Desenvolvimento
- Adicione/modifique assinaturas
- Execute testes localmente
- Atualize documentação se necessário

### 3. Submissão
- Abra Pull Request com descrição clara
- Inclua exemplos de teste
- Responda a feedbacks rapidamente

### 4. Revisão
- Aguarde revisão automatizada
- Participe de discussões
- Faça ajustes conforme solicitado

## 📚 Recursos Úteis

### Documentação:
- [PowerShell Documentation](https://docs.microsoft.com/powershell/)
- [MITRE ATT&CK Framework](https://attack.mitre.org/)
- [Regex Testing](https://regex101.com/)

### Ferramentas:
- PowerShell ISE/VS Code para desenvolvimento
- RegEx testers online
- PowerShell cmdlets de validação

## 🤝 Código de Conduta

- Seja respeitoso e construtivo
- Foque na qualidade das contribuições
- Ajude outros contribuidores
- Mantenha discussões técnicas e relevantes

## ❓ Dúvidas?

- Abra uma [Discussion](../../discussions)
- Crie uma [Issue](../../issues) para bugs
- Consulte o [Wiki](../../wiki) para documentação detalhada

---

**Obrigado por ajudar a tornar o PowerShell mais seguro! 🔒**
