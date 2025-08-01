param(
    [string]$Path = ".\signatures"
)

Write-Host "Validating PowerShell signatures in: $Path" -ForegroundColor Cyan
Write-Host "=" * 50

$errors = @()
$warnings = @()
$totalFiles = 0

# Buscar todos os arquivos .ps1 na pasta signatures
Get-ChildItem -Path $Path -Filter "*.ps1" -Recurse | ForEach-Object {
    $file = $_
    $totalFiles++
    $content = Get-Content $file.FullName -Raw
    
    Write-Host "`nValidating: $($file.Name)" -ForegroundColor Yellow
    
    # Headers obrigatorios
    $requiredHeaders = @('.SYNOPSIS', '.DESCRIPTION', '.SEVERITY', '.CATEGORY', '.SCORE', '.REGEX')
    
    foreach ($header in $requiredHeaders) {
        if ($content -notmatch "(?m)^\s*$header\s*$") {
            $errors += "ERROR File '$($file.Name)': Missing required header '$header'"
        } else {
            Write-Host "  OK $header found" -ForegroundColor Green
        }
    }
    
    # Validar valor de SEVERITY
    if ($content -match '\.SEVERITY\s*\n\s*(\w+)') {
        $severity = $matches[1].Trim()
        $validSeverities = @('critical', 'high', 'medium', 'low')
        if ($severity -in $validSeverities) {
            Write-Host "  OK Severity: $severity" -ForegroundColor Green
        } else {
            $errors += "ERROR File '$($file.Name)': Invalid severity '$severity'. Must be one of: $($validSeverities -join ', ')"
        }
    }
    
    # Validar SCORE (1-100)
    if ($content -match '\.SCORE\s*\n\s*(\d+)') {
        $score = [int]$matches[1]
        if ($score -ge 1 -and $score -le 100) {
            Write-Host "  OK Score: $score" -ForegroundColor Green
        } else {
            $errors += "ERROR File '$($file.Name)': Score must be between 1-100, got $score"
        }
    }
    
    # Validar CATEGORY
    if ($content -match '\.CATEGORY\s*\n\s*(.+)') {
        $category = $matches[1].Trim()
        $validCategories = @(
            'credential-theft', 'persistence', 'lateral-movement', 'ransomware',
            'obfuscation', 'download-execute', 'privilege-escalation', 'other'
        )
        if ($category -in $validCategories) {
            Write-Host "  OK Category: $category" -ForegroundColor Green
        } else {
            $warnings += "WARNING File '$($file.Name)': Unusual category '$category'"
        }
    }
    
    # Testar padrao REGEX
    if ($content -match '\.REGEX\s*\n\s*(.+)') {
        $regexPattern = $matches[1].Trim()
        try {
            $testRegex = [regex]::new($regexPattern)
            Write-Host "  OK Regex pattern is valid" -ForegroundColor Green
            
            # Verificar se regex nao e muito generica
            if ($regexPattern.Length -lt 5) {
                $warnings += "WARNING File '$($file.Name)': Regex pattern might be too generic: '$regexPattern'"
            }
        } catch {
            $errors += "ERROR File '$($file.Name)': Invalid regex pattern '$regexPattern': $($_.Exception.Message)"
        }
    }
    
    # Verificar se tem exemplos
    if ($content -match '\.EXAMPLES\s*\n((?:.|\n)*?)#>') {
        $examples = $matches[1].Trim()
        if ($examples) {
            Write-Host "  OK Examples found" -ForegroundColor Green
        } else {
            $warnings += "WARNING File '$($file.Name)': No examples provided"
        }
    } else {
        $warnings += "WARNING File '$($file.Name)': No examples section found"
    }
    
    # Verificar localizacao do arquivo vs categoria
    if ($content -match '\.CATEGORY\s*\n\s*(.+)') {
        $category = $matches[1].Trim()
        $filePath = $file.FullName.Replace($Path, "").Replace("\", "/")
        
        if (-not $filePath.Contains($category)) {
            $warnings += "WARNING File '$($file.Name)': File location doesn't match category '$category'"
        }
    }
}

# Relatorio final
Write-Host "`n" + "=" * 50
Write-Host "VALIDATION REPORT" -ForegroundColor Cyan
Write-Host "=" * 50

Write-Host "Total files processed: $totalFiles" -ForegroundColor White

if ($errors.Count -eq 0) {
    Write-Host "No errors found!" -ForegroundColor Green
} else {
    Write-Host "`nERRORS ($($errors.Count)):" -ForegroundColor Red
    $errors | ForEach-Object { Write-Host $_ -ForegroundColor Red }
}

if ($warnings.Count -gt 0) {
    Write-Host "`nWARNINGS ($($warnings.Count)):" -ForegroundColor Yellow
    $warnings | ForEach-Object { Write-Host $_ -ForegroundColor Yellow }
}

Write-Host "`n" + "=" * 50

if ($errors.Count -gt 0) {
    Write-Host "VALIDATION FAILED" -ForegroundColor Red
    exit 1
} else {
    Write-Host "VALIDATION PASSED" -ForegroundColor Green
    exit 0
}
