.{
  # Import necessary assemblies
  Add-Type -AssemblyName PresentationFramework

  # Define constants for paths and URLs
  $scriptRoot = $PSScriptRoot
  if (-not $scriptRoot) {
    $scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Definition
  }
  $firefoxImagePath = "C:\Users\rocket\Github\Assets-Icons\selfhst icons\png\firefox.png"

  # Load the XAML
  $xaml = [xml]@"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Modern WPF UI"
        Height="700" Width="600"
        Background="#1E1E1E">
    <Grid>
        <Grid.RowDefinitions>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="*"/>
        </Grid.RowDefinitions>

        <Label Grid.Row="0" HorizontalAlignment="Center" VerticalAlignment="Top" Margin="0,10,0,10">
            <TextBlock Text="🚀⚡️ Welcome to the Power Greeter ⚡️🚀" Foreground="Yellow" FontSize="18" FontWeight="Bold"/>
        </Label>

        <StackPanel Grid.Row="1" Orientation="Vertical" HorizontalAlignment="Center">
            <Button x:Name="ReadMeButton" Width="260" Height="45" Margin="0,10,0,0" Background="#323232" Foreground="White" FontSize="11" FontWeight="Bold">
                <StackPanel Orientation="Horizontal">
                    <Image x:Name="ReadMeImage" Width="20" Height="20" Margin="5,0,5,0"/>
                    <TextBlock Text="ReadMe" VerticalAlignment="Center"/>
                </StackPanel>
            </Button>
            <Button x:Name="UniGetUIButton" Content="📦 UniGetUI + Bundles" Width="260" Height="45" Margin="0,10,0,0" Background="#323232" Foreground="White" FontSize="11" FontWeight="Bold"/>
            <Button x:Name="DotfilesButton" Content="📝 Dotfiles" Width="260" Height="45" Margin="0,10,0,0" Background="#323232" Foreground="White" FontSize="11" FontWeight="Bold"/>
            <Button x:Name="DirectoriesButton" Content="📁 Directories" Width="260" Height="45" Margin="0,10,0,0" Background="#323232" Foreground="White" FontSize="11" FontWeight="Bold"/>
            <Button x:Name="TitusWinUtilButton" Content="💻 Titus WinUtil" Width="260" Height="45" Margin="0,10,0,0" Background="#323232" Foreground="White" FontSize="11" FontWeight="Bold"/>
            <Button x:Name="ScriptBinButton" Content="🗑️ Script Bin" Width="260" Height="45" Margin="0,10,0,0" Background="#323232" Foreground="White" FontSize="11" FontWeight="Bold"/>
            <Button x:Name="MembersOnlyButton" Content="🔒 Members Only" Width="260" Height="45" Margin="0,10,0,0" Background="#323232" Foreground="White" FontSize="11" FontWeight="Bold"/>
        </StackPanel>
    </Grid>
</Window>
"@

  # Load the XAML into a reader
  $reader = New-Object System.Xml.XmlNodeReader($xaml)
  $window = [Windows.Markup.XamlReader]::Load($reader)

  # Get the buttons
  $ReadMeButton = $window.FindName("ReadMeButton")
  $UniGetUIButton = $window.FindName("UniGetUIButton")
  $DotfilesButton = $window.FindName("DotfilesButton")
  $DirectoriesButton = $window.FindName("DirectoriesButton")
  $TitusWinUtilButton = $window.FindName("TitusWinUtilButton")
  $ScriptBinButton = $window.FindName("ScriptBinButton")
  $MembersOnlyButton = $window.FindName("MembersOnlyButton")

  # Set the image source dynamically
  $firefoxImage = $window.FindName("ReadMeImage")
  $firefoxImage.Source = [System.Windows.Media.Imaging.BitmapImage]::new([System.Uri]::new($firefoxImagePath))

  # Add hover effects
  $buttons = @($ReadMeButton, $UniGetUIButton, $DotfilesButton, $DirectoriesButton, $TitusWinUtilButton, $ScriptBinButton, $MembersOnlyButton)
  foreach ($button in $buttons) {
    $button.Add_MouseEnter({
        $this.Background = [System.Windows.Media.Brushes]::LightSkyBlue
      })
    $button.Add_MouseLeave({
        $this.Background = [System.Windows.Media.Brushes]::Gray
      })
  }

  # Add click actions
  $ReadMeButton.Add_Click({
      Start-Process "firefox" https://rocketdashboard.notion.site/pwr-windows-Cheat-Sheet-1b8627bc6fd880998e75e7191f8ffffe
    })

  $UniGetUIButton.Add_Click({
      Start-Process pwsh -ArgumentList @('-File', 'C:\Users\rocket\GitHub-pwr\windows-greeter\button_open_UniGetUI.ps1')
    })

  $DotfilesButton.Add_Click({
      Start-Process "notepad"
    })

  $DirectoriesButton.Add_Click({
      Start-Process "explorer"
    })

  $TitusWinUtilButton.Add_Click({
      Start-Process pwsh -ArgumentList @('-NoProfile', '-Command', '(irm ''https://christitus.com/win'') | iex')
    })

  $ScriptBinButton.Add_Click({
      Start-Process "shell:RecycleBinFolder"
    })

  $MembersOnlyButton.Add_Click({
      Start-Process "control" "ncpa.cpl"
    })

  # Show the window
  $window.ShowDialog()
}