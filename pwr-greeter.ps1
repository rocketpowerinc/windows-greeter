.{
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Define a custom class for button state management
Add-Type -TypeDefinition @"
public class ButtonState {
    public System.Drawing.Color OriginalColor { get; set; }
    public string Action { get; set; }
}
"@

# Create the main form
$Form = New-Object System.Windows.Forms.Form
$Form.Text = "Modern WinForm UI"
$Form.Size = New-Object System.Drawing.Size(600, 700)
$Form.StartPosition = "CenterScreen"
$Form.BackColor = [System.Drawing.Color]::FromArgb(30, 30, 30)

# Function to create a button
Function New-Button {
  param(
    [string]$Text,
    [string]$Action
  )

  $Button = New-Object System.Windows.Forms.Button
  $Button.Text = $Text
  $Button.Size = New-Object System.Drawing.Size(260, 45)
  $Button.FlatStyle = "Flat"
  $Button.FlatAppearance.BorderSize = 0
  $Button.BackColor = [System.Drawing.Color]::FromArgb(50, 50, 50)
  $Button.ForeColor = [System.Drawing.Color]::White
  $Button.Font = New-Object System.Drawing.Font("Segoe UI Emoji", 11, [System.Drawing.FontStyle]::Bold)

  # Store state in dedicated object
  $Button.Tag = New-Object ButtonState -Property @{
    OriginalColor = $Button.BackColor
    Action        = $Action
  }

  # Hover effects
  $Button.Add_MouseEnter({
      $this.BackColor = [System.Drawing.Color]::FromArgb(70, 130, 180)
    })
  $Button.Add_MouseLeave({
      $this.BackColor = $this.Tag.OriginalColor
    })

  # Click action
  $Button.Add_Click({
      if ($this.Tag.Action.StartsWith("cmd:")) {
        Start-Process $this.Tag.Action.Substring(4)
      }
      else {
        Start-Process "firefox" $this.Tag.Action
      }
    })
  return $Button
}

# Button configurations
$ButtonData = @(
  @{ Text = "📖 ReadMe"; Action = "https://www.xbox.com" },
  @{ Text = "📦 Package Bundles"; Action = "https://example.com/packages" },
  @{ Text = "🖥️ Task Manager"; Action = "cmd:taskmgr" },
  @{ Text = "⚙️ System Settings"; Action = "cmd:ms-settings:" },
  @{ Text = "📝 Notepad"; Action = "cmd:notepad" },
  @{ Text = "📁 File Explorer"; Action = "cmd:explorer" },
  @{ Text = "🧮 Calculator"; Action = "cmd:calc" },
  @{ Text = "💻 PowerShell"; Action = "cmd:powershell" },
  @{ Text = "🗑️ Recycle Bin"; Action = "cmd:shell:RecycleBinFolder" },
  @{ Text = "🌐 Network Settings"; Action = "cmd:control ncpa.cpl" }
)

# Add buttons to form
$yPos = 20
foreach ($ButtonInfo in $ButtonData) {
  $Button = New-Button -Text $ButtonInfo.Text -Action $ButtonInfo.Action
  $Button.Location = New-Object System.Drawing.Point(160, $yPos)
  $Form.Controls.Add($Button)
  $yPos += 55
}

# Show the form
$Form.ShowDialog()
}