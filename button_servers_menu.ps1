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
$Selfhost_AkaiGrid_Button = New-Button "📥 Selfhost AkaiGrid"
$buttonsPanel.Children.Add($Selfhost_AkaiGrid_Button)

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

$Selfhost_AkaiGrid_Button.Add_Click({
    # Define paths
    $downloadUrl = (Invoke-RestMethod "https://api.github.com/repos/louislam/akaigrid/releases/latest").assets[0].browser_download_url
    $archivePath = "$env:USERPROFILE\Downloads\akaigrid-latest.7z"
    $destination = "$env:USERPROFILE\Downloads\akaigrid"

    # Download the file
    Invoke-WebRequest -Uri $downloadUrl -OutFile $archivePath

    # Extract using 7-Zip
    & "C:\Program Files\7-Zip\7z.exe" x $archivePath -o"$destination" -y

    # Delete .7z file
    & "C:\Program Files\7-Zip\7z.exe" x $archivePath -o"$destination" -y
    Remove-Item -Path $archivePath

    Move-Item -Path "$destination\*" -Destination "$env:USERPROFILE" -Force

    Remove-Item -Path "$destination"

    Add-Type -AssemblyName System.Windows.Forms

    # Open folder picker
    $dialog = New-Object System.Windows.Forms.FolderBrowserDialog
    $dialog.Description = "Choose a folder for AkaiGrid"
    $dialog.ShowNewFolderButton = $true

    if ($dialog.ShowDialog() -eq "OK") {
      $selectedPath = $dialog.SelectedPath
      $configPath = "$env:USERPROFILE\AkaiGrid\config.yaml"

      if (Test-Path $configPath) {
        $lines = Get-Content $configPath
        $newLines = @()
        $inFoldersBlock = $false

        foreach ($line in $lines) {
          if ($line -match "^\s*folders:\s*$") {
            $newLines += $line
            $inFoldersBlock = $true
            continue
          }

          if ($inFoldersBlock) {
            if ($line -match "^\s*- ") {
              # Skip existing folder lines
              continue
            }
            else {
              # End of folders block
              $newLines += "  - $selectedPath"
              $inFoldersBlock = $false
            }
          }

          $newLines += $line
        }

        # If folders were at the end, append the selected folder path
        if ($inFoldersBlock) {
          $newLines += "  - $selectedPath"
        }

        Set-Content -Path $configPath -Value $newLines -Encoding UTF8
        Write-Host "✅ Folder list updated with: $selectedPath"
      }
      else {
        Write-Host "❌ Config file not found at $configPath"
      }
    }
    else {
      Write-Host "🚫 Folder selection canceled."
    }

    Push-Location "$env:USERPROFILE\AkaiGrid"
    & ".\AkaiGrid.exe"
    Pop-Location
  })

#*#############################################################################################################
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

##############################################################################################################

$source_Default_Powershell_Profile_Button.Add_Click({ Write-Host "Sourcing Default Powershell Profile..." })

##############################################################################################################


$source_WSL_Bash_Dotfile_Button.Add_Click({ Write-Host "Sourcing WSL Bash Dotfile..." })

# Set the window content to the Dotfiles menu
$window.Content = $dotfilesMenu
