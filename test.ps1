.{
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

  # Open a custom file dialog to select a script from the target directory
  Add-Type -AssemblyName System.Windows.Forms

  # Create a new file dialog
  $openFileDialog = New-Object System.Windows.Forms.OpenFileDialog
  $openFileDialog.InitialDirectory = $localBinPath
  $openFileDialog.Filter = "PowerShell Scripts (*.ps1)|*.ps1|All Files (*.*)|*.*"
  $openFileDialog.Title = "Select a Script"

  if ($openFileDialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
    $selectedScript = $openFileDialog.FileName

    # Custom Windows Form for script actions
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Script Action"
    $form.Size = New-Object System.Drawing.Size(300, 150)
    $form.StartPosition = "CenterScreen"

    # Add label
    $label = New-Object System.Windows.Forms.Label
    $label.Text = "What would you like to do with the script?"
    $label.AutoSize = $true
    $label.Location = New-Object System.Drawing.Point(50, 20)
    $form.Controls.Add($label)

    # Add buttons
    $readButton = New-Object System.Windows.Forms.Button
    $readButton.Text = "Read"
    $readButton.Location = New-Object System.Drawing.Point(30, 60)
    $readButton.Add_Click({
        $global:userAction = "Read"
        $form.Close()
      })
    $form.Controls.Add($readButton)

    $runButton = New-Object System.Windows.Forms.Button
    $runButton.Text = "Run"
    $runButton.Location = New-Object System.Drawing.Point(120, 60)
    $runButton.Add_Click({
        $global:userAction = "Run"
        $form.Close()
      })
    $form.Controls.Add($runButton)

    $cancelButton = New-Object System.Windows.Forms.Button
    $cancelButton.Text = "Cancel"
    $cancelButton.Location = New-Object System.Drawing.Point(210, 60)
    $cancelButton.Add_Click({
        $global:userAction = "Cancel"
        $form.Close()
      })
    $form.Controls.Add($cancelButton)

    # Show the form
    $form.ShowDialog()

    # Perform actions based on user choice
    if ($global:userAction -eq "Read") {
      notepad.exe $selectedScript
    }
    elseif ($global:userAction -eq "Run") {
      Start-Process pwsh.exe -ArgumentList "-File", $selectedScript -NoNewWindow
    }
  }

  # Clean up
  Remove-Item -Recurse -Force -Path $downloadPath
}