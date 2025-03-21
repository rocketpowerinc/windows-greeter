.{
  # Import necessary assemblies
  Add-Type -AssemblyName PresentationFramework

  # Define constants for paths and URLs
  $url = "https://github.com/kangyu-california/PersistentWindows/releases/download/5.62/PersistentWindows5.62.zip"
  $destinationPath = Join-Path $env:USERPROFILE "Downloads\PersistentWindows5.62.zip"
  $extractPath = Join-Path $env:USERPROFILE "Downloads\PersistentWindows"
  $executablePath = Join-Path $extractPath "PersistentWindows.exe"


  # Function to install PersistentWindows if not present
  Function Install-PersistentWindows {
    if (!(Test-Path -Path $executablePath)) {
      Write-Output "PersistentWindows not found. Installing..."

      # Download the file
      Invoke-WebRequest -Uri $url -OutFile $destinationPath

      # Create the extraction folder if it doesn't exist
      if (!(Test-Path -Path $extractPath)) {
        New-Item -ItemType Directory -Path $extractPath
      }

      # Unzip the downloaded file
      Expand-Archive -Path $destinationPath -DestinationPath $extractPath -Force

      # Delete the zip file after extraction
      Remove-Item -Path $destinationPath -Force

      Write-Output "Installation completed. Extracted files are located in: $extractPath"
    }
    else {
      Write-Output "PersistentWindows is already installed."
    }
  }

  # Call the installation function
  Install-PersistentWindows

  # Create the WPF form
  [xml]$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Persistent Windows Manager"
        Height="200" Width="400" Background="#2B2B2B" WindowStartupLocation="CenterScreen">
    <Grid>
        <Grid.RowDefinitions>
            <RowDefinition Height="*"/>
            <RowDefinition Height="*"/>
        </Grid.RowDefinitions>
        <Button x:Name="Group1Button" Content="Persistent Windows Group 1" Grid.Row="0" Margin="10" Background="#3C3C3C" Foreground="White" FontSize="14" FontWeight="Bold"/>
        <Button x:Name="Group2Button" Content="Persistent Windows Group 2" Grid.Row="1" Margin="10" Background="#3C3C3C" Foreground="White" FontSize="14" FontWeight="Bold"/>
    </Grid>
</Window>
"@

  # Load the XAML into a reader
  $reader = New-Object System.Xml.XmlNodeReader $xaml
  $window = [Windows.Markup.XamlReader]::Load($reader)

  # Get the buttons
  $Group1Button = $window.FindName("Group1Button")
  $Group2Button = $window.FindName("Group2Button")

  # Define button click actions
  $Group1Button.Add_Click({
      (New-Object -ComObject Shell.Application).MinimizeAll()
      Start-Process "C:\Users\rocket\AppData\Local\Programs\Notion\Notion.exe"
      Start-Process "C:\Users\rocket\AppData\Local\Programs\todoist\Todoist.exe"
      Start-Process "C:\Program Files\Mozilla Firefox\firefox.exe"
      Start-Sleep -Milliseconds 1000
      C:\Users\rocket\Downloads\PersistentWindows\PersistentWindows.exe -restore_snapshot "0"
    })

  $Group2Button.Add_Click({
      (New-Object -ComObject Shell.Application).MinimizeAll()
      Start-Process "ChatGPT.exe"
      Start-Process "C:\Users\rocket\pwr-vscode\Code.exe" -ArgumentList "C:\Users\rocket\GitHub-pwr\windows-greeter"
      Start-Sleep -Milliseconds 1000
      Start-Process -FilePath $executablePath -ArgumentList '-restore_snapshot "1"'
      C:\Users\rocket\Downloads\PersistentWindows\PersistentWindows.exe -restore_snapshot "1"
    })

  # Show the WPF form
  $window.ShowDialog()
}