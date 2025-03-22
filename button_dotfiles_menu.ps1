param(
  [Parameter(Mandatory = $true)]
  $MainMenuGrid
)

$window.FindName("DotfilesButton").Add_Click({
    # Create a new Grid for Dotfiles Menu
    $dotfilesMenu = New-Object System.Windows.Controls.Grid
    $dotfilesMenu.Margin = "0,20,0,0"

    # Add RowDefinitions to the new Grid
    $dotfilesMenu.RowDefinitions.Add((New-Object System.Windows.Controls.RowDefinition))
    $dotfilesMenu.RowDefinitions.Add((New-Object System.Windows.Controls.RowDefinition))
    $dotfilesMenu.RowDefinitions.Add((New-Object System.Windows.Controls.RowDefinition))
    $dotfilesMenu.RowDefinitions.Add((New-Object System.Windows.Controls.RowDefinition))
    $dotfilesMenu.RowDefinitions.Add((New-Object System.Windows.Controls.RowDefinition))

    # Create buttons for Dotfiles Menu
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

    # Add Click Handlers for Buttons
    $copyProfileButton.Add_Click({
        Write-Host "Copying PowerShell Profile..."
        # Add logic for copying the profile
      })

    $wslDotfileButton.Add_Click({
        Write-Host "Accessing WSL Bash Dotfile..."
        # Add logic for WSL Bash dotfiles
      })

    $dotfilesButton.Add_Click({
        Write-Host "Viewing Dotfiles..."
        # Logic to view the Dotfiles
      })

    # Go back to the main menu when "Back" button is clicked
    $backButton.Add_Click({
        # Return to the original main menu
        $window.Content = $MainMenuGrid
      })

    # Replace the current window content with the Dotfiles menu
    $window.Content = $dotfilesMenu
  })
