Add-Type -AssemblyName System.Drawing

Write-Host ""
Write-Host "===========================================================" -ForegroundColor Cyan
Write-Host "  CREADOR DE IMAGENES PARA INSTALADOR PITHY              " -ForegroundColor Cyan
Write-Host "===========================================================" -ForegroundColor Cyan
Write-Host ""

$outputPath = $PSScriptRoot

# 1. Crear imagen lateral (164x314)
Write-Host "Creando imagen lateral (164x314 px)..." -ForegroundColor Yellow

$lateral = New-Object System.Drawing.Bitmap 164, 314
$g1 = [System.Drawing.Graphics]::FromImage($lateral)
$g1.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$g1.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAlias

# Fondo gradiente azul-morado
$brush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
    [System.Drawing.Point]::new(0,0),
    [System.Drawing.Point]::new(0,314),
    [System.Drawing.Color]::FromArgb(102,126,234),
    [System.Drawing.Color]::FromArgb(118,75,162)
)
$g1.FillRectangle($brush, 0, 0, 164, 314)

# Texto "PITHY"
$font1 = New-Object System.Drawing.Font("Arial", 20, [System.Drawing.FontStyle]::Bold)
$g1.DrawString("PITHY", $font1, [System.Drawing.Brushes]::White, 35, 230)

# Texto "Chatbot"
$font2 = New-Object System.Drawing.Font("Arial", 12)
$g1.DrawString("Chatbot", $font2, [System.Drawing.Brushes]::White, 45, 260)

# Versión
$font3 = New-Object System.Drawing.Font("Arial", 9)
$g1.DrawString("v1.0", $font3, [System.Drawing.Brushes]::White, 65, 285)

# Guardar
$lateralPath = "$outputPath\WizModernImage.bmp"
$lateral.Save($lateralPath)
$g1.Dispose()
$lateral.Dispose()
$brush.Dispose()
$font1.Dispose()
$font2.Dispose()
$font3.Dispose()

Write-Host "   OK: WizModernImage.bmp creado" -ForegroundColor Green

# 2. Crear banner pequeño (55x58)
Write-Host "Creando banner superior (55x58 px)..." -ForegroundColor Yellow

$banner = New-Object System.Drawing.Bitmap 55, 58
$g2 = [System.Drawing.Graphics]::FromImage($banner)
$g2.Clear([System.Drawing.Color]::FromArgb(102,126,234))

# Letra P grande
$fontP = New-Object System.Drawing.Font("Arial", 32, [System.Drawing.FontStyle]::Bold)
$g2.DrawString("P", $fontP, [System.Drawing.Brushes]::White, 10, 8)

$bannerPath = "$outputPath\WizModernSmallImage.bmp"
$banner.Save($bannerPath)
$g2.Dispose()
$banner.Dispose()
$fontP.Dispose()

Write-Host "   OK: WizModernSmallImage.bmp creado" -ForegroundColor Green

Write-Host ""
Write-Host "===========================================================" -ForegroundColor Green
Write-Host "  IMAGENES CREADAS EXITOSAMENTE                          " -ForegroundColor Green
Write-Host "===========================================================" -ForegroundColor Green
Write-Host ""
Write-Host "Archivos creados en: $outputPath" -ForegroundColor White
Write-Host "   - WizModernImage.bmp (164x314 px)" -ForegroundColor Cyan
Write-Host "   - WizModernSmallImage.bmp (55x58 px)" -ForegroundColor Cyan
Write-Host ""
Write-Host "El icono favicon.ico ya existe en:" -ForegroundColor Green
Write-Host "   - img\favicon.ico" -ForegroundColor Cyan
Write-Host ""
Write-Host "LISTO PARA COMPILAR EL INSTALADOR!" -ForegroundColor Green
Write-Host ""
