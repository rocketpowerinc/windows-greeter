param(
  [Parameter(Mandatory = $true)]
  $PreviousContent  # Store entire previous content
)

# Create Dotfiles menu grid
$dotfilesMenu = New-Object System.Windows.Controls.Grid
$dotfilesMenu.Margin = "0,20,0,0"

# Add rows
for ($i = 0; $i -lt 5; $i++) {
  $dotfilesMenu.RowDefinitions.Add((New-Object System.Windows.Controls.RowDefinition))
}

# Create buttons
$copyProfileButton = New-Object System.Windows.Controls.Button
$copyProfileButton.Content = "📋 Copy PowerShell Profile"
$copyProfileButton.Margin = "10"
$dotfilesMenu.Children.Add($copyProfileButton)
[System.Windows.Controls.Grid]::SetRow($copyProfileButton, 0)

$wslDotfileButton = New-Object System.Windows.Controls.Button
$wslDotfileButton.Content = "🖥️ WSL Bash Dotfile"
$wslDotfileButton.Margin = "10"
$dotfilesMenu.Children.Add($wslDotfileButton)
[System.Windows.Controls.Grid]::SetRow($wslDotfileButton, 1)

$dotfilesButton = New-Object System.Windows.Controls.Button
$dotfilesButton.Content = "📄 View Dotfiles"
$dotfilesButton.Margin = "10"
$dotfilesMenu.Children.Add($dotfilesButton)
[System.Windows.Controls.Grid]::SetRow($dotfilesButton, 2)

$backButton = New-Object System.Windows.Controls.Button
$backButton.Content = "🔙 Back to Main Menu"
$backButton.Margin = "10"
$dotfilesMenu.Children.Add($backButton)
[System.Windows.Controls.Grid]::SetRow($backButton, 3)

# Back button to restore previous content
$backButton.Add_Click({
    $window.Content = $PreviousContent
  })

# Show the Dotfiles menu
$window.Content = $dotfilesMenu
