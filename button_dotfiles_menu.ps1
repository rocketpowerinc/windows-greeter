# Create a new Grid layout for the Dotfiles Menu
$dotfilesMenu = New-Object System.Windows.Controls.Grid

# Set the row definitions to create space for the TextBlock, buttons, and Back button
$dotfilesMenu.RowDefinitions.Add((New-Object System.Windows.Controls.RowDefinition))  # For the TextBlock
$dotfilesMenu.RowDefinitions.Add((New-Object System.Windows.Controls.RowDefinition))  # For the Buttons
$dotfilesMenu.RowDefinitions.Add((New-Object System.Windows.Controls.RowDefinition))  # For the Back Button
$dotfilesMenu.RowDefinitions[1].Height = [System.Windows.GridLength]::Auto  # Buttons should fit content

# Add the Title TextBlock at the top (Row 0)
$textBlock = New-Object System.Windows.Controls.TextBlock
$textBlock.Text = "Choose Which Dotfile to Copy"
$textBlock.FontSize = 20
$textBlock.FontWeight = "Bold"
$textBlock.Foreground = "White"
$textBlock.HorizontalAlignment = "Center"
$textBlock.Margin = "0,10,0,20"
$dotfilesMenu.Children.Add($textBlock)
[System.Windows.Controls.Grid]::SetRow($textBlock, 0)

# Create a StackPanel to hold buttons, and center them
$buttonsPanel = New-Object System.Windows.Controls.StackPanel
$buttonsPanel.Orientation = "Vertical"  # Stack buttons vertically
$buttonsPanel.HorizontalAlignment = "Center"  # Center buttons horizontally

# Function to Create Buttons with Customizable Colors
function New-Button($content, $backgroundColor, $textColor) {
  $btn = New-Object System.Windows.Controls.Button
  $btn.Content = $content
  $btn.Margin = "10,5,10,5"  # Adjust margin for consistent spacing
  $btn.Background = $backgroundColor  # Set the background color
  $btn.Foreground = $textColor  # Set the text color
  return $btn
}

# Create Buttons and add them to the StackPanel with custom colors
$refresh_Dotfiles_Button = New-Button "♻️ Refresh Dotfiles" [System.Windows.Media.Brushes]::Green [System.Windows.Media.Brushes]::White
$buttonsPanel.Children.Add($refresh_Dotfiles_Button)

$copy_PWSH_Profile_Button = New-Button "📋 Source pwsh 7+ Profile" [System.Windows.Media.Brushes]::Blue [System.Windows.Media.Brushes]::White
$buttonsPanel.Children.Add($copy_PWSH_Profile_Button)

$copy_Default_Powershell_Profile_Button = New-Button "📋 Source Powershell Profile" [System.Windows.Media.Brushes]::Orange [System.Windows.Media.Brushes]::White
$buttonsPanel.Children.Add($copy_Default_Powershell_Profile_Button)

$copy_WSL_Bash_Dotfile_Button = New-Button "📋 Source WSL bashrc" [System.Windows.Media.Brushes]::Purple [System.Windows.Media.Brushes]::White
$buttonsPanel.Children.Add($copy_WSL_Bash_Dotfile_Button)

# Add buttons panel to Grid at Row 1
$dotfilesMenu.Children.Add($buttonsPanel)
[System.Windows.Controls.Grid]::SetRow($buttonsPanel, 1)

# Back Button at the Absolute Bottom (Row 2)
$backButton = New-Object System.Windows.Controls.Button
$backButton.Content = "🔙 Back to Main Menu"
$backButton.Margin = "10,10,10,10"
$backButton.Background = [System.Windows.Media.Brushes]::DarkRed
$backButton.Foreground = [System.Windows.Media.Brushes]::White
$backButton.FontWeight = "Bold"
$backButton.BorderBrush = [System.Windows.Media.Brushes]::Blue
$backButton.BorderThickness = 2
$backButton.Padding = "5"

# Add the Back Button to the Grid at Row 2
$dotfilesMenu.Children.Add($backButton)
[System.Windows.Controls.Grid]::SetRow($backButton, 2)

# Back Button Click Event
$backButton.Add_Click({
    if ($global:MainMenuGrid) {
      $window.Content = $global:MainMenuGrid
    }
    else {
      Write-Host "Error: Main menu content not found!"
    }
  })

# Button Click Handlers
$refresh_Dotfiles_Button.Add_Click({ Write-Host "Refreshing Dotfiles..." })
$copy_PWSH_Profile_Button.Add_Click({ Write-Host "Copying pwsh 7+ Profile..." })
$copy_Default_Powershell_Profile_Button.Add_Click({ Write-Host "Copying Default Powershell Profile..." })
$copy_WSL_Bash_Dotfile_Button.Add_Click({ Write-Host "Copying WSL Bash Dotfile..." })

# Set the window content to the Dotfiles menu
$window.Content = $dotfilesMenu
