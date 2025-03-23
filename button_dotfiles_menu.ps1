# Create a new DockPanel for layout (Ensures back button stays at the bottom)
$dotfilesMenu = New-Object System.Windows.Controls.DockPanel
$dotfilesMenu.LastChildFill = $true  # Ensures remaining space is filled properly

# Add Title TextBlock
$textBlock = New-Object System.Windows.Controls.TextBlock
$textBlock.Text = "Choose Which Dotfile to Copy"
$textBlock.FontSize = 20
$textBlock.FontWeight = "Bold"
$textBlock.Foreground = "White"
$textBlock.HorizontalAlignment = "Center"
$textBlock.Margin = "0,10,0,20"

# Create a StackPanel to hold buttons (Prevents excessive spacing)
$buttonsPanel = New-Object System.Windows.Controls.StackPanel
$buttonsPanel.HorizontalAlignment = "Center"

# Function to Create Buttons with Uniform Spacing
function New-Button($content) {
    $btn = New-Object System.Windows.Controls.Button
    $btn.Content = $content
    $btn.Margin = "10,5,10,5"  # Adjust margin to reduce spacing
    return $btn
}

# Create Buttons
$refresh_Dotfiles_Button = New-Button "♻️ Refresh Dotfiles"
$buttonsPanel.Children.Add($refresh_Dotfiles_Button)

$copy_PWSH_Profile_Button = New-Button "📋 Source pwsh 7+ Profile"
$buttonsPanel.Children.Add($copy_PWSH_Profile_Button)

$copy_Default_Powershell_Profile_Button = New-Button "📋 Source Powershell Profile"
$buttonsPanel.Children.Add($copy_Default_Powershell_Profile_Button)

$copy_WSL_Bash_Dotfile_Button = New-Button "📋 Source WSL bashrc"
$buttonsPanel.Children.Add($copy_WSL_Bash_Dotfile_Button)

# Back Button at the Absolute Bottom
$backButton = New-Object System.Windows.Controls.Button
$backButton.Content = "🔙 Back to Main Menu"
$backButton.Margin = "10,10,10,10"
$backButton.Background = [System.Windows.Media.Brushes]::DarkRed
$backButton.Foreground = [System.Windows.Media.Brushes]::White
$backButton.FontWeight = "Bold"
$backButton.BorderBrush = [System.Windows.Media.Brushes]::Blue
$backButton.BorderThickness = 2
$backButton.Padding = "5"

# Dock the Back Button at the Bottom
[System.Windows.Controls.DockPanel]::SetDock($backButton, "Bottom")

# Add Items to DockPanel
$dotfilesMenu.Children.Add($backButton)  # This goes to the bottom
$dotfilesMenu.Children.Add($buttonsPanel)  # Buttons stay in the center
$dotfilesMenu.Children.Add($textBlock)  # Title stays on top

# Back Button Click Event
$backButton.Add_Click({
    if ($global:MainMenuGrid) {
        $window.Content = $global:MainMenuGrid
    } else {
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
