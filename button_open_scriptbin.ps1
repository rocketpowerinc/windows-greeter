.{
  Write-Host 'MAKE SURE TO EXPORT THESE PATHS IN notepad $PROFILE.CurrentUserAllHosts' -ForegroundColor red
  Write-Host '$Env:Path += ";$env:USERPROFILE\Bin"' -ForegroundColor red
  Write-Host '$Env:Path += ";$env:USERPROFILE\Bin\Templates"' -ForegroundColor red
  Write-Host '$Env:Path += ";$env:USERPROFILE\Bin\Cross-Platform-Powershell"' -ForegroundColor red
  Write-Host 'WARNING SCRIPTS WILL BE OVERWRITTEN BUT NOT DELETED IF OMITED FROM CURRENT SCRIPTBIN SCRIPTS' -ForegroundColor red

  # Define the repository URL and the download path
  $repoUrl = "https://github.com/rocketpowerinc/scriptbin.git"
  $downloadPath = "$env:USERPROFILE\Downloads\scriptbin"

  # Clean up any previous download
  if (Test-Path -Path $downloadPath) {
    Remove-Item -Recurse -Force -Path $downloadPath
  }

  # Clone the repository
  git clone $repoUrl $downloadPath

  # Copy scripts to a target directory
  $localBinPath = "$env:USERPROFILE\Bin"
  New-Item -ItemType Directory -Force -Path $localBinPath | Out-Null
  Copy-Item -Path "$downloadPath\Windows\*" -Destination $localBinPath -Recurse -Force
  Copy-Item -Path "$downloadPath\Cross-Platform-Powershell" -Destination $localBinPath -Recurse -Force


  # Open a file dialog to select a script from the target directory
  Add-Type -AssemblyName System.Windows.Forms

  # Create a file dialog
  $openFileDialog = New-Object System.Windows.Forms.OpenFileDialog
  $openFileDialog.InitialDirectory = $localBinPath
  $openFileDialog.Filter = "PowerShell Scripts (*.ps1)|*.ps1|All Files (*.*)|*.*"
  $openFileDialog.Title = "Select a Script"

  if ($openFileDialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
    $selectedScript = $openFileDialog.FileName

    # Local variable to track the user's action
    $userAction = $null

    # Create a custom form for script actions
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Script Action"
    $form.Size = New-Object System.Drawing.Size(300, 150)
    $form.StartPosition = "CenterScreen"

    # Add a label
    $label = New-Object System.Windows.Forms.Label
    $label.Text = "What would you like to do with the script?"
    $label.AutoSize = $true
    $label.Location = New-Object System.Drawing.Point(50, 20)
    $form.Controls.Add($label)

    # Add "Read" button
    $readButton = New-Object System.Windows.Forms.Button
    $readButton.Text = "Read"
    $readButton.Location = New-Object System.Drawing.Point(30, 60)
    $readButton.Add_Click({
        $form.Tag = "Read"
        $form.Close()
      })
    $form.Controls.Add($readButton)

    # Add "Run" button
    $runButton = New-Object System.Windows.Forms.Button
    $runButton.Text = "Run"
    $runButton.Location = New-Object System.Drawing.Point(120, 60)
    $runButton.Add_Click({
        $form.Tag = "Run"
        $form.Close()
      })
    $form.Controls.Add($runButton)

    # Add "Cancel" button
    $cancelButton = New-Object System.Windows.Forms.Button
    $cancelButton.Text = "Cancel"
    $cancelButton.Location = New-Object System.Drawing.Point(210, 60)
    $cancelButton.Add_Click({
        $form.Tag = "Cancel"
        $form.Close()
      })
    $form.Controls.Add($cancelButton)

    # Show the custom form and capture the result
    $form.ShowDialog()
    $userAction = $form.Tag

    # Perform actions based on user choice
    if ($userAction -eq "Read") {
      notepad.exe $selectedScript
    }
    elseif ($userAction -eq "Run") {
      Start-Process pwsh.exe -ArgumentList "-File", $selectedScript -NoNewWindow
    }
  }

  # Clean up
  Remove-Item -Recurse -Force -Path $downloadPath


}