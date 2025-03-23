# Create a new Grid for Dotfiles Menu
$dotfilesMenu = New-Object System.Windows.Controls.Grid
$dotfilesMenu.Margin = "0,20,0,0"

# Add RowDefinitions to the new Grid
for ($i = 0; $i -lt 6; $i++) {
  # Increased to 6 rows to add space for the TextBlock and better spacing
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

# Create buttons for Dotfiles Menu
$copy_PWSH_Profile_Button = New-Object System.Windows.Controls.Button
$copy_PWSH_Profile_Button.Content = "📋 PWSH Profile"
$copy_PWSH_Profile_Button.Margin = "10,5,10,5"  # Adjusted margin for consistent spacing
$dotfilesMenu.Children.Add($copy_PWSH_Profile_Button)
[System.Windows.Controls.Grid]::SetRow($copy_PWSH_Profile_Button, 1)

$copy_Default_Powershell_Profile_Button = New-Object System.Windows.Controls.Button
$copy_Default_Powershell_Profile_Button.Content = "📄 Default Powershell Profile"
$copy_Default_Powershell_Profile_Button.Margin = "10,5,10,5"  # Adjusted margin for consistent spacing
$dotfilesMenu.Children.Add($copy_Default_Powershell_Profile_Button)
[System.Windows.Controls.Grid]::SetRow($copy_Default_Powershell_Profile_Button, 2)

$copy_WSL_Bash_Dotfile_Button = New-Object System.Windows.Controls.Button
$copy_WSL_Bash_Dotfile_Button.Content = "🖥️ WSL Bash Dotfile"
$copy_WSL_Bash_Dotfile_Button.Margin = "10,5,10,5"  # Adjusted margin for consistent spacing
$dotfilesMenu.Children.Add($copy_WSL_Bash_Dotfile_Button)
[System.Windows.Controls.Grid]::SetRow($copy_WSL_Bash_Dotfile_Button, 3)

# Create a Back button with enhanced styling
$backButton = New-Object System.Windows.Controls.Button
$backButton.Content = "🔙 Back to Main Menu"
$backButton.Margin = "10,15,10,5"  # Added extra top margin for better spacing
$backButton.Background = [System.Windows.Media.Brushes]::DarkRed  # Set background color
$backButton.Foreground = [System.Windows.Media.Brushes]::White    # Set text color
$backButton.FontWeight = "Bold"                                   # Make the text bold
$backButton.BorderBrush = [System.Windows.Media.Brushes]::Blue    # Add a blue border
$backButton.BorderThickness = 2                                   # Set border thickness
$backButton.Padding = "5"                                         # Add padding for better appearance

# Add a StackPanel to style the button content
$backButtonContent = New-Object System.Windows.Controls.StackPanel
$backButtonContent.Orientation = "Horizontal"

# Add a colored symbol to the button
$backButtonSymbol = New-Object System.Windows.Controls.TextBlock
$backButtonSymbol.Text = "🔙"
$backButtonSymbol.Foreground = [System.Windows.Media.Brushes]::Gold  # Set symbol color to gold
$backButtonSymbol.FontSize = 16
$backButtonContent.Children.Add($backButtonSymbol)

# Add the text to the button
$backButtonText = New-Object System.Windows.Controls.TextBlock
$backButtonText.Text = "Back to Main Menu"
$backButtonText.Foreground = [System.Windows.Media.Brushes]::White
$backButtonText.FontWeight = "Bold"
$backButtonText.Margin = "5,0,0,0"  # Add spacing between the symbol and text
$backButtonContent.Children.Add($backButtonText)

# Set the button's content to the styled StackPanel
$backButton.Content = $backButtonContent

# Add the button to the grid
$dotfilesMenu.Children.Add($backButton)
[System.Windows.Controls.Grid]::SetRow($backButton, 4)

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
$copy_PWSH_Profile_Button.Add_Click({
    Write-Host "Copying PWSH 7 Profile..."
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