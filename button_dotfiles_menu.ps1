# Create a new Grid for Dotfiles Menu
$dotfilesMenu = New-Object System.Windows.Controls.Grid
$dotfilesMenu.Margin = "0,20,0,0"

# Define Grid Rows: Fixed Height for Buttons, Star (*) for Back Button
for ($i = 0; $i -lt 5; $i++) {
    $row = New-Object System.Windows.Controls.RowDefinition
    $row.Height = "Auto"  # Ensures rows only take as much space as needed
    $dotfilesMenu.RowDefinitions.Add($row)
}

# Last Row (Back Button) Takes Remaining Space
$lastRow = New-Object System.Windows.Controls.RowDefinition
$lastRow.Height = "*"  # Makes the back button stay at the bottom
$dotfilesMenu.RowDefinitions.Add($lastRow)

# Add Title TextBlock
$textBlock = New-Object System.Windows.Controls.TextBlock
$textBlock.Text = "Choose Which Dotfile to Copy"
$textBlock.FontSize = 20
$textBlock.FontWeight = "Bold"
$textBlock.Foreground = "White"
$textBlock.HorizontalAlignment = "Center"
$textBlock.Margin = "0,10,0,20"
$dotfilesMenu.Children.Add($textBlock)
[System.Windows.Controls.Grid]::SetRow($textBlock, 0)

# Function to Create Buttons
function New-Button($content) {
    $btn = New-Object System.Windows.Controls.Button
    $btn.Content = $content
    $btn.Margin = "10,0,10,0"  # Removes vertical gaps
    return $btn
}

# Create Buttons
$refresh_Dotfiles_Button = New-Button "♻️ Refresh Dotfiles"
$dotfilesMenu.Children.Add($refresh_Dotfiles_Button)
[System.Windows.Controls.Grid]::SetRow($refresh_Dotfiles_Button, 1)

$copy_PWSH_Profile_Button = New-Button "📋 Source pwsh 7+ Profile"
$dotfilesMenu.Children.Add($copy_PWSH_Profile_Button)
[System.Windows.Controls.Grid]::SetRow($copy_PWSH_Profile_Button, 2)

$copy_Default_Powershell_Profile_Button = New-Button "📋 Source Powershell Profile"
$dotfilesMenu.Children.Add($copy_Default_Powershell_Profile_Button)
[System.Windows.Controls.Grid]::SetRow($copy_Default_Powershell_Profile_Button, 3)

$copy_WSL_Bash_Dotfile_Button = New-Button "📋 Source WSL bashrc"
$dotfilesMenu.Children.Add($copy_WSL_Bash_Dotfile_Button)
[System.Windows.Controls.Grid]::SetRow($copy_WSL_Bash_Dotfile_Button, 4)

# Back Button at the Bottom
$backButton = New-Object System.Windows.Controls.Button
$backButton.Content = "🔙 Back to Main Menu"
$backButton.Margin = "10,10,10,10"  # Gives it space from the bottom
$backButton.Background = [System.Windows.Media.Brushes]::DarkRed
$backButton.Foreground = [System.Windows.Media.Brushes]::White
$backButton.FontWeight = "Bold"
$backButton.BorderBrush = [System.Windows.Media.Brushes]::Blue
$backButton.BorderThickness = 2
$backButton.Padding = "5"

# StackPanel for Back Button Content
$backButtonContent = New-Object System.Windows.Controls.StackPanel
$backButtonContent.Orientation = "Horizontal"

$backButtonSymbol = New-Object System.Windows.Controls.TextBlock
$backButtonSymbol.Text = "🔙"
$backButtonSymbol.Foreground = [System.Windows.Media.Brushes]::Gold
$backButtonSymbol.FontSize = 16
$backButtonContent.Children.Add($backButtonSymbol)

$backButtonText = New-Object System.Windows.Controls.TextBlock
$backButtonText.Text = "Back to Main Menu"
$backButtonText.Foreground = [System.Windows.Media.Brushes]::White
$backButtonText.FontWeight = "Bold"
$backButtonText.Margin = "5,0,0,0"
$backButtonContent.Children.Add($backButtonText)

$backButton.Content = $backButtonContent
$dotfilesMenu.Children.Add($backButton)
[System.Windows.Controls.Grid]::SetRow($backButton, 5)  # Sticks to the last row

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
