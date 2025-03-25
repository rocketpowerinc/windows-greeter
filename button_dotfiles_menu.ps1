# Create a new Grid layout for the Dotfiles Menu
$dotfilesMenu = New-Object System.Windows.Controls.Grid

# Set the row definitions to create space for the TextBlock, buttons, and Back button
$dotfilesMenu.RowDefinitions.Add((New-Object System.Windows.Controls.RowDefinition))  # For the TextBlock
$dotfilesMenu.RowDefinitions.Add((New-Object System.Windows.Controls.RowDefinition))  # For the Buttons
$dotfilesMenu.RowDefinitions.Add((New-Object System.Windows.Controls.RowDefinition))  # For the Back Button
$dotfilesMenu.RowDefinitions[1].Height = [System.Windows.GridLength]::Auto  # Buttons should fit content

# Add the Title TextBlock at the top (Row 0)
$textBlock = New-Object System.Windows.Controls.TextBlock
$textBlock.Text = "Dotiles Menu"
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

# Function to Create Buttons with Uniform Spacing
function New-Button($content) {
  $btn = New-Object System.Windows.Controls.Button
  $btn.Content = $content
  $btn.Margin = "10,5,10,5"  # Adjust margin for consistent spacing
  return $btn
}

# Create Buttons and add them to the StackPanel
$refresh_Dotfiles_Button = New-Button "♻️ Refresh Dotfiles"
$buttonsPanel.Children.Add($refresh_Dotfiles_Button)

$source_PWSH_Profile_Button = New-Button "📋 Source pwsh 7+ Profile"
$buttonsPanel.Children.Add($source_PWSH_Profile_Button)

$source_Default_Powershell_Profile_Button = New-Button "📋 Source Powershell Profile"
$buttonsPanel.Children.Add($source_Default_Powershell_Profile_Button)

$source_WSL_Bash_Dotfile_Button = New-Button "📋 Source WSL bashrc"
$buttonsPanel.Children.Add($source_WSL_Bash_Dotfile_Button)

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

#*################### Button Click Handlers ######################
$refresh_Dotfiles_Button.Add_Click({
    try {
      # Define the target directory for the dotfiles
      $dotfilesPath = Join-Path $env:USERPROFILE "Github-pwr\dotfiles"

      # Ensure the parent directory exists
      $githubPath = Join-Path $env:USERPROFILE "Github-pwr"
      if (-not (Test-Path $githubPath)) {
        New-Item -ItemType Directory -Path $githubPath -Force | Out-Null
      }

      # Remove the existing dotfiles directory if it exists
      if (Test-Path $dotfilesPath) {
        Remove-Item -Recurse -Force -Path $dotfilesPath
      }

      # Clone the dotfiles repository
      git clone https://github.com/rocketpowerinc/dotfiles $dotfilesPath

      # Display a success message
      Write-Host "All dotfiles refreshed!" -ForegroundColor Green
    }
    catch {
      # Handle errors and display an error message
      Write-Host "An error occurred while refreshing dotfiles: $($_.Exception.Message)" -ForegroundColor Red
    }
  })
$source_PWSH_Profile_Button.Add_Click({
    try {
      # Define the path to the pwsh profile
      $profilePath = $PROFILE.CurrentUserAllHosts
      $GithubDotfilesPath = Join-Path $env:USERPROFILE "Github-pwr\dotfiles\pwsh\profile.ps1"
      $sourceLine = ". `"$GithubDotfilesPath`""  # Corrected quoting and added space before the path

      # Determine the directory containing the profile (no need for $configDir here)
      $profileDirectory = Split-Path -Path $profilePath -Parent

      # Ensure the directory exists
      if (-not (Test-Path $profileDirectory)) {
        New-Item -ItemType Directory -Path $profileDirectory -Force | Out-Null
      }

      # Ensure the profile.ps1 file exists
      if (-not (Test-Path $profilePath)) {
        New-Item -ItemType File -Path $profilePath -Force | Out-Null
      }

      # Check if the profile already sources the dotfiles profile
      if (-not (Get-Content $profilePath | Where-Object { $_ -like "*$($sourceLine.TrimStart('.'))*" })) {
        # Using -like for more robust matching and trimming initial dot
        Add-Content -Path $profilePath -Value $sourceLine
        Write-Host "pwsh profile has been sourced!" -ForegroundColor Green
      }
      else {
        Write-Host "pwsh profile already sourced!" -ForegroundColor Yellow
      }
    }
    catch {
      Write-Host "An error occurred while sourcing the pwsh profile: $($_.Exception.Message)" -ForegroundColor Red
    }
  })
$source_Default_Powershell_Profile_Button.Add_Click({ Write-Host "Sourcing Default Powershell Profile..." })
$source_WSL_Bash_Dotfile_Button.Add_Click({ Write-Host "Sourcing WSL Bash Dotfile..." })

# Set the window content to the Dotfiles menu
$window.Content = $dotfilesMenu
