# Create a new Grid for Dotfiles Menu
$dotfilesMenu = New-Object System.Windows.Controls.Grid
$dotfilesMenu.Margin = "0,20,0,0"

# Add RowDefinitions to the new Grid
for ($i = 0; $i -lt 5; $i++) {
  $dotfilesMenu.RowDefinitions.Add((New-Object System.Windows.Controls.RowDefinition))
}

# Create buttons for Dotfiles Menu
$copy_PWSH_Profile_Button = New-Object System.Windows.Controls.Button
$copy_PWSH_Profile_Button.Content = "📋 Copy PowerShell Profile"
$copy_PWSH_Profile_Button.Margin = "10"
$dotfilesMenu.Children.Add($copy_PWSH_Profile_Button)
[System.Windows.Controls.Grid]::SetRow($copy_PWSH_Profile_Button, 0)


$copy_Default_Powershell_Profile_Button = New-Object System.Windows.Controls.Button
$copy_Default_Powershell_Profile_Button.Content = "📄 View Dotfiles"
$copy_Default_Powershell_Profile_Button.Margin = "10"
$dotfilesMenu.Children.Add($copy_Default_Powershell_Profile_Button)
[System.Windows.Controls.Grid]::SetRow($copy_Default_Powershell_Profile_Button, 1)


$Copy_WSL_Bash_Dotfile_Button = New-Object System.Windows.Controls.Button
$Copy_WSL_Bash_Dotfile_Button.Content = "🖥️ WSL Bash Dotfile"
$Copy_WSL_Bash_Dotfile_Button.Margin = "10"
$dotfilesMenu.Children.Add($Copy_WSL_Bash_Dotfile_Button)
[System.Windows.Controls.Grid]::SetRow($Copy_WSL_Bash_Dotfile_Button, 2)

$backButton = New-Object System.Windows.Controls.Button
$backButton.Content = "🔙 Back to Main Menu"
$backButton.Margin = "10"
$dotfilesMenu.Children.Add($backButton)
[System.Windows.Controls.Grid]::SetRow($backButton, 3)

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

$Copy_WSL_Bash_Dotfile_Button.Add_Click({
    Write-Host "Copying WSL Bash Dotfile..."
    # Logic to view the Dotfiles
  })

# Replace the window content with the Dotfiles menu
$window.Content = $dotfilesMenu
