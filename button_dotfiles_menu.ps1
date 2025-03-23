# Create a new Grid for Dotfiles Menu
$dotfilesMenu = New-Object System.Windows.Controls.Grid
$dotfilesMenu.Margin = "0,20,0,0"

# Add ColumnDefinitions to create two columns
$dotfilesMenu.ColumnDefinitions.Add((New-Object System.Windows.Controls.ColumnDefinition))
$dotfilesMenu.ColumnDefinitions.Add((New-Object System.Windows.Controls.ColumnDefinition))

# Add RowDefinitions to the new Grid
for ($i = 0; $i -lt 3; $i++) {
  $dotfilesMenu.RowDefinitions.Add((New-Object System.Windows.Controls.RowDefinition))
}

# Add a TextBlock to the top of the Dotfiles Menu
$textBlock = New-Object System.Windows.Controls.TextBlock
$textBlock.Text = "Choose Which Dotfile to Copy"
$textBlock.FontSize = 20
$textBlock.FontWeight = "Bold"
$textBlock.Foreground = "White"
$textBlock.HorizontalAlignment = "Center"
$textBlock.Margin = "0,10,0,20"  # Added margin to create space between the TextBlock and buttons
$dotfilesMenu.Children.Add($textBlock)
[System.Windows.Controls.Grid]::SetRow($textBlock, 0)
[System.Windows.Controls.Grid]::SetColumnSpan($textBlock, 2)  # Span across both columns

# Add or Refresh Dotfiles Directory
$refresh_Dotfiles_Button = New-Object System.Windows.Controls.Button
$refresh_Dotfiles_Button.Content = "♻️ Refresh Dotfiles"
$refresh_Dotfiles_Button.Margin = "10,2,10,2"  # Reduced vertical margin
$dotfilesMenu.Children.Add($refresh_Dotfiles_Button)
[System.Windows.Controls.Grid]::SetRow($refresh_Dotfiles_Button, 1)
[System.Windows.Controls.Grid]::SetColumn($refresh_Dotfiles_Button, 0)

# Create buttons for Dotfiles Menu
$copy_PWSH_Profile_Button = New-Object System.Windows.Controls.Button
$copy_PWSH_Profile_Button.Content = "📋 Source pwsh 7+ Profile"
$copy_PWSH_Profile_Button.Margin = "10,2,10,2"  # Reduced vertical margin
$dotfilesMenu.Children.Add($copy_PWSH_Profile_Button)
[System.Windows.Controls.Grid]::SetRow($copy_PWSH_Profile_Button, 1)
[System.Windows.Controls.Grid]::SetColumn($copy_PWSH_Profile_Button, 1)

$copy_Default_Powershell_Profile_Button = New-Object System.Windows.Controls.Button
$copy_Default_Powershell_Profile_Button.Content = "📋 Source Powershell Profile"
$copy_Default_Powershell_Profile_Button.Margin = "10,2,10,2"  # Reduced vertical margin
$dotfilesMenu.Children.Add($copy_Default_Powershell_Profile_Button)
[System.Windows.Controls.Grid]::SetRow($copy_Default_Powershell_Profile_Button, 2)
[System.Windows.Controls.Grid]::SetColumn($copy_Default_Powershell_Profile_Button, 0)

$copy_WSL_Bash_Dotfile_Button = New-Object System.Windows.Controls.Button
$copy_WSL_Bash_Dotfile_Button.Content = "📋 Source WSL bashrc"
$copy_WSL_Bash_Dotfile_Button.Margin = "10,2,10,2"  # Reduced vertical margin
$dotfilesMenu.Children.Add($copy_WSL_Bash_Dotfile_Button)
[System.Windows.Controls.Grid]::SetRow($copy_WSL_Bash_Dotfile_Button, 2)
[System.Windows.Controls.Grid]::SetColumn($copy_WSL_Bash_Dotfile_Button, 1)

# Create a Back button with enhanced styling
$backButton = New-Object System.Windows.Controls.Button
$backButton.Content = "🔙 Back to Main Menu"
$backButton.Margin = "10,10,10,2"  # Slightly larger top margin for separation
$backButton.Background = [System.Windows.Media.Brushes]::DarkRed  # Set background color
$backButton.Foreground = [System.Windows.Media.Brushes]::White    # Set text color
$backButton.FontWeight = "Bold"                                   # Make the text bold
$backButton.BorderBrush = [System.Windows.Media.Brushes]::Blue    # Add a blue border
$backButton.BorderThickness = 2                                   # Set border thickness
$backButton.Padding = "5"                                         # Add padding for better appearance
$dotfilesMenu.Children.Add($backButton)
[System.Windows.Controls.Grid]::SetRow($backButton, 3)
[System.Windows.Controls.Grid]::SetColumnSpan($backButton, 2)  # Span across both columns

# Back button to restore the original main menu
$backButton.Add_Click({
    if ($global:MainMenuGrid) {
      $window.Content = $global:MainMenuGrid
    }
    else {
      Write-Host "Error: Main menu content not found!"
    }
  })

#*##############   Add Click Handlers for Buttons   #########################

$refresh_Dotfiles_Button.Add_Click({
    Write-Host "Refreshing Dotfiles..."
    # Add logic for copying the profile
  })


$copy_PWSH_Profile_Button.Add_Click({
    Write-Host "Copying pwsh 7+ Profile..."
    # Add logic for copying the profile
  })

$copy_Default_Powershell_Profile_Button.Add_Click({
    Write-Host "Copying Default Powershell Profile..."
    # Add logic for WSL Bash dotfiles
  })

$copy_WSL_Bash_Dotfile_Button.Add_Click({
    Write-Host "Copying WSL Bash Dotfile..."
    # Logic to view the Dotfiles
  })

# Replace the window content with the Dotfiles menu
$window.Content = $dotfilesMenu