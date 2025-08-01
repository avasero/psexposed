---
name: Nova Assinatura PowerShell
about: Propor uma nova assinatura para detectar comandos PowerShell maliciosos/suspeitos
title: '[SIGNATURE] '
labels: ['nova-assinatura', 'review-needed']
assignees: ''

---

## 📝 Informações da Assinatura

**Nome da Assinatura:**
<!-- Nome descritivo da assinatura -->

**Categoria:**
<!-- escolha uma: credential-theft, persistence, lateral-movement, ransomware, obfuscation, download-execute, privilege-escalation, other -->

**Severidade:**
<!-- escolha uma: critical, high, medium, low -->

**Pontuação (1-100):**
<!-- Pontuação de risco -->

## 🎯 Descrição

**O que detecta:**
<!-- Descreva claramente o que esta assinatura detecta -->

**Por que é importante:**
<!-- Explique por que é importante detectar este padrão -->

## 🔍 Padrão Regex

```regex
<!-- Cole aqui o padrão regex -->
```

**Flags do Regex:**
<!-- i, g, m, etc. -->

## 💡 Exemplos

### Comandos que devem ser detectados:
```powershell
# Exemplo 1
comando-exemplo-1

# Exemplo 2
comando-exemplo-2
```

### Comandos que NÃO devem ser detectados (falsos positivos):
```powershell
# Comando legítimo 1
comando-legitimo-1

# Comando legítimo 2
comando-legitimo-2
```

## 🧪 Testes

- [ ] Testei o regex com exemplos positivos
- [ ] Testei o regex com possíveis falsos positivos
- [ ] Verifiquei se não duplica assinaturas existentes
- [ ] Validei a pontuação de severidade

## 📚 Referências

<!-- Links para documentação, artigos, relatórios de segurança, etc. -->

## ✅ Checklist

- [ ] Preenchei todas as informações obrigatórias
- [ ] Testei o padrão regex
- [ ] Verifiquei falsos positivos
- [ ] Incluí exemplos relevantes
- [ ] Classifiquei corretamente a severidade
