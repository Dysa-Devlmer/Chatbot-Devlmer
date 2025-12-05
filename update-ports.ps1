# Script para actualizar puertos en archivos del proyecto
Write-Host "Actualizando puertos en archivos del proyecto..." -ForegroundColor Yellow

$files = Get-ChildItem -Path "E:\prueba" -Include *.ps1,*.bat,*.md,*.txt -Recurse |
    Where-Object { $_.FullName -notlike "*node_modules*" -and $_.FullName -notlike "*.next*" }

foreach ($file in $files) {
    try {
        $content = Get-Content $file.FullName -Raw -ErrorAction SilentlyContinue
        if ($content) {
            $updated = $content -replace 'localhost:3000', 'localhost:7847' `
                                -replace 'localhost:4040', 'localhost:4847' `
                                -replace 'http 3000', 'http 7847' `
                                -replace ':3000', ':7847'

            if ($updated -ne $content) {
                Set-Content -Path $file.FullName -Value $updated -NoNewline
                Write-Host "✓ Actualizado: $($file.Name)" -ForegroundColor Green
            }
        }
    } catch {
        Write-Host "✗ Error en: $($file.Name)" -ForegroundColor Red
    }
}

Write-Host "`nActualización completada!" -ForegroundColor Green
