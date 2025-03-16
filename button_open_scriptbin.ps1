# Define the repository URL and the download path
$repoUrl = "https://github.com/rocketpowerinc/scriptbin.git"
$downloadPath = "$env:USERPROFILE\Downloads\scriptbin"

# Clean up any previous download
if (Test-Path -Path $downloadPath) {
  Remove-Item -Recurse -Force -Path $downloadPath
}

# Clone the repository
git clone $repoUrl $downloadPath -ErrorAction Stop

# Copy scripts to a target directory
$localBinPath = "$env:USERPROFILE\Bin"
New-Item -ItemType Directory -Force -Path $localBinPath | Out-Null
Copy-Item -Path "$downloadPath\Windows\*" -Destination $localBinPath -Recurse -Force

# Make all scripts executable
Get-ChildItem -Path $localBinPath -File | ForEach-Object {
  $_.Attributes = 'ReadOnly, Archive'
}

# Open file selection dialog
Add-Type -AssemblyName Microsoft.VisualBasic
$script = [Microsoft.VisualBasic.Interaction]::InputBox(
  "Type or paste the path of the script you want to select:",
  "Select a Script"
)

# Check if a script was selected
if (-not [string]::IsNullOrWhiteSpace($script) -and (Test-Path -Path $script)) {
  # Open the script for editing (Notepad is used as an example)
  notepad.exe $script

  # Confirm whether the user wants to execute the script
  $userResponse = [System.Windows.Forms.MessageBox]::Show(
    "Do you want to run the selected script?",
    "Run Script",
    [System.Windows.Forms.MessageBoxButtons]::YesNo,
    [System.Windows.Forms.MessageBoxIcon]::Question
  )

  if ($userResponse -eq [System.Windows.Forms.DialogResult]::Yes) {
    # Run the selected script
    Start-Process pwsh.exe -ArgumentList "-File", $script -NoNewWindow
  }
}

# Clean up
Remove-Item -Recurse -Force -Path $downloadPath
