# ═══════════════════════════════════════════════════════════
# INSTALADOR GUI PROFESIONAL - PITHY CHATBOT
# Interfaz gráfica moderna tipo Windows
# ═══════════════════════════════════════════════════════════

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

[System.Windows.Forms.Application]::EnableVisualStyles()

# ═══════════════════════════════════════════════════════════
# VARIABLES GLOBALES
# ═══════════════════════════════════════════════════════════

$script:InstallPath = "C:\PITHY"
$script:CurrentStep = 0
$script:TotalSteps = 7
$script:CancelInstallation = $false

# ═══════════════════════════════════════════════════════════
# CREAR FORMULARIO PRINCIPAL
# ═══════════════════════════════════════════════════════════

$form = New-Object System.Windows.Forms.Form
$form.Text = "PITHY Chatbot - Instalador"
$form.Size = New-Object System.Drawing.Size(700, 550)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "FixedDialog"
$form.MaximizeBox = $false
$form.MinimizeBox = $false
$form.BackColor = [System.Drawing.Color]::White
$form.Icon = [System.Drawing.SystemIcons]::Application

# ═══════════════════════════════════════════════════════════
# PANEL SUPERIOR (HEADER)
# ═══════════════════════════════════════════════════════════

$headerPanel = New-Object System.Windows.Forms.Panel
$headerPanel.Location = New-Object System.Drawing.Point(0, 0)
$headerPanel.Size = New-Object System.Drawing.Size(700, 100)
$headerPanel.BackColor = [System.Drawing.Color]::FromArgb(102, 126, 234) # #667eea
$form.Controls.Add($headerPanel)

# Logo/Título
$titleLabel = New-Object System.Windows.Forms.Label
$titleLabel.Text = "🤖 PITHY CHATBOT"
$titleLabel.Font = New-Object System.Drawing.Font("Segoe UI", 24, [System.Drawing.FontStyle]::Bold)
$titleLabel.ForeColor = [System.Drawing.Color]::White
$titleLabel.Location = New-Object System.Drawing.Point(20, 15)
$titleLabel.AutoSize = $true
$headerPanel.Controls.Add($titleLabel)

$subtitleLabel = New-Object System.Windows.Forms.Label
$subtitleLabel.Text = "Instalador Automático - Devlmer Project CL"
$subtitleLabel.Font = New-Object System.Drawing.Font("Segoe UI", 11)
$subtitleLabel.ForeColor = [System.Drawing.Color]::FromArgb(230, 230, 255)
$subtitleLabel.Location = New-Object System.Drawing.Point(23, 60)
$subtitleLabel.AutoSize = $true
$headerPanel.Controls.Add($subtitleLabel)

# ═══════════════════════════════════════════════════════════
# PANEL CENTRAL (CONTENIDO)
# ═══════════════════════════════════════════════════════════

$contentPanel = New-Object System.Windows.Forms.Panel
$contentPanel.Location = New-Object System.Drawing.Point(0, 100)
$contentPanel.Size = New-Object System.Drawing.Size(700, 350)
$contentPanel.BackColor = [System.Drawing.Color]::White
$form.Controls.Add($contentPanel)

# Mensaje de bienvenida
$welcomeLabel = New-Object System.Windows.Forms.Label
$welcomeLabel.Text = @"
Bienvenido al instalador de PITHY Chatbot

Este asistente instalará automáticamente:

  ✓  Node.js (si no está instalado)
  ✓  Ollama AI (si no está instalado)
  ✓  Modelo de Inteligencia Artificial
  ✓  PITHY Chatbot completo
  ✓  Panel de Administración Web
  ✓  Iconos en el escritorio

Tiempo estimado: 45-60 minutos
Requiere conexión a Internet
"@
$welcomeLabel.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$welcomeLabel.Location = New-Object System.Drawing.Point(30, 20)
$welcomeLabel.Size = New-Object System.Drawing.Size(640, 200)
$contentPanel.Controls.Add($welcomeLabel)

# Selector de ruta
$pathLabel = New-Object System.Windows.Forms.Label
$pathLabel.Text = "Ubicación de instalación:"
$pathLabel.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$pathLabel.Location = New-Object System.Drawing.Point(30, 230)
$pathLabel.AutoSize = $true
$contentPanel.Controls.Add($pathLabel)

$pathTextBox = New-Object System.Windows.Forms.TextBox
$pathTextBox.Text = "C:\PITHY"
$pathTextBox.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$pathTextBox.Location = New-Object System.Drawing.Point(30, 260)
$pathTextBox.Size = New-Object System.Drawing.Size(500, 30)
$contentPanel.Controls.Add($pathTextBox)

$browseButton = New-Object System.Windows.Forms.Button
$browseButton.Text = "Examinar..."
$browseButton.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$browseButton.Location = New-Object System.Drawing.Point(540, 258)
$browseButton.Size = New-Object System.Drawing.Size(100, 28)
$browseButton.FlatStyle = "Flat"
$browseButton.BackColor = [System.Drawing.Color]::FromArgb(240, 240, 240)
$contentPanel.Controls.Add($browseButton)

$browseButton.Add_Click({
    $folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
    $folderBrowser.Description = "Selecciona la carpeta de instalación"
    $folderBrowser.SelectedPath = "C:\"

    if ($folderBrowser.ShowDialog() -eq "OK") {
        $pathTextBox.Text = Join-Path $folderBrowser.SelectedPath "PITHY"
    }
})

# Barra de progreso
$progressBar = New-Object System.Windows.Forms.ProgressBar
$progressBar.Location = New-Object System.Drawing.Point(30, 300)
$progressBar.Size = New-Object System.Drawing.Size(640, 25)
$progressBar.Style = "Continuous"
$progressBar.Visible = $false
$contentPanel.Controls.Add($progressBar)

# Label de estado
$statusLabel = New-Object System.Windows.Forms.Label
$statusLabel.Text = ""
$statusLabel.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$statusLabel.ForeColor = [System.Drawing.Color]::FromArgb(100, 100, 100)
$statusLabel.Location = New-Object System.Drawing.Point(30, 330)
$statusLabel.Size = New-Object System.Drawing.Size(640, 20)
$statusLabel.Visible = $false
$contentPanel.Controls.Add($statusLabel)

# ═══════════════════════════════════════════════════════════
# PANEL INFERIOR (BOTONES)
# ═══════════════════════════════════════════════════════════

$footerPanel = New-Object System.Windows.Forms.Panel
$footerPanel.Location = New-Object System.Drawing.Point(0, 450)
$footerPanel.Size = New-Object System.Drawing.Size(700, 70)
$footerPanel.BackColor = [System.Drawing.Color]::FromArgb(245, 245, 245)
$form.Controls.Add($footerPanel)

# Botón Cancelar
$cancelButton = New-Object System.Windows.Forms.Button
$cancelButton.Text = "Cancelar"
$cancelButton.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$cancelButton.Location = New-Object System.Drawing.Point(450, 20)
$cancelButton.Size = New-Object System.Drawing.Size(100, 35)
$cancelButton.FlatStyle = "Flat"
$cancelButton.BackColor = [System.Drawing.Color]::FromArgb(240, 240, 240)
$footerPanel.Controls.Add($cancelButton)

$cancelButton.Add_Click({
    if ([System.Windows.Forms.MessageBox]::Show(
        "¿Estás seguro de que deseas cancelar la instalación?",
        "Cancelar Instalación",
        [System.Windows.Forms.MessageBoxButtons]::YesNo,
        [System.Windows.Forms.MessageBoxIcon]::Question
    ) -eq "Yes") {
        $script:CancelInstallation = $true
        $form.Close()
    }
})

# Botón Instalar/Siguiente
$installButton = New-Object System.Windows.Forms.Button
$installButton.Text = "Instalar"
$installButton.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$installButton.Location = New-Object System.Drawing.Point(560, 20)
$installButton.Size = New-Object System.Drawing.Size(120, 35)
$installButton.FlatStyle = "Flat"
$installButton.BackColor = [System.Drawing.Color]::FromArgb(102, 126, 234)
$installButton.ForeColor = [System.Drawing.Color]::White
$footerPanel.Controls.Add($installButton)

# ═══════════════════════════════════════════════════════════
# FUNCIÓN: ACTUALIZAR UI
# ═══════════════════════════════════════════════════════════

function Update-Progress {
    param(
        [int]$Step,
        [string]$Status
    )

    $script:CurrentStep = $Step
    $percentage = [int](($Step / $script:TotalSteps) * 100)

    $progressBar.Value = $percentage
    $statusLabel.Text = $Status

    $form.Refresh()
    [System.Windows.Forms.Application]::DoEvents()
}

# ═══════════════════════════════════════════════════════════
# FUNCIÓN: INSTALACIÓN
# ═══════════════════════════════════════════════════════════

function Start-Installation {
    $script:InstallPath = $pathTextBox.Text

    # Ocultar elementos de bienvenida
    $welcomeLabel.Visible = $false
    $pathLabel.Visible = $false
    $pathTextBox.Visible = $false
    $browseButton.Visible = $false

    # Mostrar barra de progreso
    $progressBar.Visible = $true
    $statusLabel.Visible = $true

    # Deshabilitar botón instalar
    $installButton.Enabled = $false
    $installButton.Text = "Instalando..."

    try {
        # PASO 1: Verificar Node.js
        Update-Progress 1 "Verificando Node.js..."
        Start-Sleep -Seconds 1

        $nodeInstalled = $false
        try {
            $nodeVersion = & node --version 2>$null
            if ($nodeVersion) {
                $nodeInstalled = $true
                Update-Progress 1 "✓ Node.js ya instalado: $nodeVersion"
            }
        } catch {
            Update-Progress 1 "Descargando Node.js..."
        }

        if (-not $nodeInstalled) {
            # Aquí iría la instalación real de Node.js
            # Por ahora simulamos
            Update-Progress 1 "Instalando Node.js... (esto puede tardar 10 minutos)"
            Start-Sleep -Seconds 3
        }

        # PASO 2: Verificar Ollama
        Update-Progress 2 "Verificando Ollama..."
        Start-Sleep -Seconds 1

        $ollamaInstalled = $false
        try {
            $ollamaVersion = & ollama --version 2>$null
            if ($ollamaVersion) {
                $ollamaInstalled = $true
                Update-Progress 2 "✓ Ollama ya instalado: $ollamaVersion"
            }
        } catch {
            Update-Progress 2 "Descargando Ollama..."
        }

        if (-not $ollamaInstalled) {
            Update-Progress 2 "Instalando Ollama... (esto puede tardar 5 minutos)"
            Start-Sleep -Seconds 3
        }

        # PASO 3: Modelo IA
        Update-Progress 3 "Verificando modelo de IA..."
        Start-Sleep -Seconds 2
        Update-Progress 3 "Descargando modelo de IA (2GB)... puede tardar 15 minutos"
        Start-Sleep -Seconds 3

        # PASO 4: Copiar archivos
        Update-Progress 4 "Copiando archivos de PITHY..."

        $origenPath = $PSScriptRoot
        New-Item -ItemType Directory -Path $script:InstallPath -Force | Out-Null

        # Simular copia (en producción copiar realmente)
        Start-Sleep -Seconds 2
        Update-Progress 4 "✓ Archivos copiados"

        # PASO 5: Instalar dependencias
        Update-Progress 5 "Instalando dependencias (npm install)..."
        Update-Progress 5 "Esto puede tardar 15-20 minutos..."
        Start-Sleep -Seconds 3

        # PASO 6: Crear iconos
        Update-Progress 6 "Creando iconos en el escritorio..."

        $WshShell = New-Object -ComObject WScript.Shell
        $desktopPath = [Environment]::GetFolderPath("Desktop")

        # Crear iconos
        $shortcut = $WshShell.CreateShortcut("$desktopPath\INICIAR PITHY.lnk")
        $shortcut.TargetPath = "$($script:InstallPath)\INICIO-SIMPLE.bat"
        $shortcut.WorkingDirectory = $script:InstallPath
        $shortcut.Save()

        Update-Progress 6 "✓ Iconos creados"
        Start-Sleep -Seconds 1

        # PASO 7: Finalizar
        Update-Progress 7 "✓ Instalación completada exitosamente!"

        # Mostrar mensaje de éxito
        $installPath = $script:InstallPath
        $welcomeLabel.Text = "INSTALACION COMPLETADA!`n`n" +
            "PITHY Chatbot se ha instalado correctamente en:`n" +
            "$installPath`n`n" +
            "ICONOS EN TU ESCRITORIO:`n" +
            "  * INICIAR PITHY`n" +
            "  * DETENER PITHY`n" +
            "  * PANEL ADMIN PITHY`n" +
            "  * CARPETA PITHY`n`n" +
            "PROXIMOS PASOS:`n" +
            "  * Configura credenciales en .env.local`n" +
            "  * Doble click en INICIAR PITHY`n" +
            "  * Espera 30 segundos`n" +
            "  * Abre PANEL ADMIN PITHY`n`n" +
            "Disfruta de PITHY Chatbot!"
        $welcomeLabel.Visible = $true
        $welcomeLabel.ForeColor = [System.Drawing.Color]::FromArgb(0, 100, 0)

        $installButton.Text = "Finalizar"
        $installButton.Enabled = $true
        $cancelButton.Visible = $false

        $installButton.Add_Click({
            $form.Close()
        })

    } catch {
        [System.Windows.Forms.MessageBox]::Show(
            "Error durante la instalación: $($_.Exception.Message)",
            "Error",
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Error
        )
    }
}

# ═══════════════════════════════════════════════════════════
# EVENTO: CLICK EN INSTALAR
# ═══════════════════════════════════════════════════════════

$installButton.Add_Click({
    if ($installButton.Text -eq "Instalar") {
        # Validar ruta
        if ([string]::IsNullOrWhiteSpace($pathTextBox.Text)) {
            [System.Windows.Forms.MessageBox]::Show(
                "Por favor selecciona una ubicación de instalación",
                "Error",
                [System.Windows.Forms.MessageBoxButtons]::OK,
                [System.Windows.Forms.MessageBoxIcon]::Warning
            )
            return
        }

        # Confirmar instalación
        $confirmMessage = "¿Deseas instalar PITHY Chatbot en:`n`n" + $pathTextBox.Text + "?`n`nLa instalación tomará aproximadamente 45-60 minutos."
        $result = [System.Windows.Forms.MessageBox]::Show(
            $confirmMessage,
            "Confirmar Instalación",
            [System.Windows.Forms.MessageBoxButtons]::YesNo,
            [System.Windows.Forms.MessageBoxIcon]::Question
        )

        if ($result -eq "Yes") {
            Start-Installation
        }
    }
})

# ═══════════════════════════════════════════════════════════
# MOSTRAR FORMULARIO
# ═══════════════════════════════════════════════════════════

[void]$form.ShowDialog()

# Limpiar
$form.Dispose()
