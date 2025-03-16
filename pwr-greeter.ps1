.{
  # Import necessary assemblies
  Add-Type -AssemblyName PresentationFramework

  # Define constants for paths and URLs
  $scriptRoot = $PSScriptRoot
  if (-not $scriptRoot) {
    $scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Definition
  }
  $firefoxImagePath = "C:\Users\rocket\Github\Assets-Icons\selfhst icons\png\firefox.png"

  # Load the XAML with enhanced design
  $xaml = [xml]@"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Modern WPF UI"
        Height="700" Width="600"
        Background="#2B2B2B"> <!-- Windows 11-like dark gray -->
    <Window.Resources>
        <!-- Define gradient and shadow styles -->
        <LinearGradientBrush x:Key="ButtonBackground" StartPoint="0,0" EndPoint="1,1">
            <GradientStop Color="#00FFFF" Offset="0.0"/> <!-- Cyan gradient -->
            <GradientStop Color="#008B8B" Offset="1.0"/> <!-- Teal gradient -->
        </LinearGradientBrush>
        <DropShadowEffect x:Key="ButtonShadow" BlurRadius="10" ShadowDepth="3" Color="Black" Opacity="0.7"/>
    </Window.Resources>
    <Grid>
        <Grid.RowDefinitions>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="*"/>
        </Grid.RowDefinitions>

        <Label Grid.Row="0" HorizontalAlignment="Center" VerticalAlignment="Top" Margin="0,10,0,10">
            <TextBlock Text="🚀⚡ Power Greeter - Cyberpunk Edition ⚡🚀" Foreground="Gold" FontSize="20" FontWeight="Bold" Effect="{StaticResource ButtonShadow}"/>
        </Label>

        <StackPanel Grid.Row="1" Orientation="Vertical" HorizontalAlignment="Center">
            <Button x:Name="ReadMeButton" Width="260" Height="45" Margin="0,10,0,0"
                    Background="{StaticResource ButtonBackground}" Foreground="White" FontSize="12" FontWeight="Bold" Effect="{StaticResource ButtonShadow}"
                    ToolTip="Open the ReadMe documentation.">
                <StackPanel Orientation="Horizontal">
                    <Image Width="20" Height="20" Margin="5,0,10,0"
                            Source="file:///$firefoxImagePath"/>
                    <TextBlock Text="ReadMe" VerticalAlignment="Center"/>
                </StackPanel>
            </Button>
            <Button x:Name="UniGetUIButton" Content="📦 UniGetUI + Bundles" Width="260" Height="45" Margin="0,10,0,0"
                    Background="{StaticResource ButtonBackground}" Foreground="White" FontSize="12" FontWeight="Bold" Effect="{StaticResource ButtonShadow}"/>
            <Button x:Name="DotfilesButton" Content="📝 Dotfiles" Width="260" Height="45" Margin="0,10,0,0"
                    Background="{StaticResource ButtonBackground}" Foreground="White" FontSize="12" FontWeight="Bold" Effect="{StaticResource ButtonShadow}"/>
            <Button x:Name="DirectoriesButton" Content="📁 Directories" Width="260" Height="45" Margin="0,10,0,0"
                    Background="{StaticResource ButtonBackground}" Foreground="White" FontSize="12" FontWeight="Bold" Effect="{StaticResource ButtonShadow}"/>
            <Button x:Name="TitusWinUtilButton" Content="💻 Titus WinUtil" Width="260" Height="45" Margin="0,10,0,0"
                    Background="{StaticResource ButtonBackground}" Foreground="White" FontSize="12" FontWeight="Bold" Effect="{StaticResource ButtonShadow}"/>
            <Button x:Name="ScriptBinButton" Content="🗑️ Script Bin" Width="260" Height="45" Margin="0,10,0,0"
                    Background="{StaticResource ButtonBackground}" Foreground="White" FontSize="12" FontWeight="Bold" Effect="{StaticResource ButtonShadow}"/>
            <Button x:Name="MembersOnlyButton" Content="🔒 Members Only" Width="260" Height="45" Margin="0,10,0,0"
                    Background="{StaticResource ButtonBackground}" Foreground="White" FontSize="12" FontWeight="Bold" Effect="{StaticResource ButtonShadow}"/>
            <Button x:Name="ToggleThemeButton" Content="🌗 Toggle Dark/Light Mode" Width="260" Height="45" Margin="0,10,0,0"
                    Background="{StaticResource ButtonBackground}" Foreground="White" FontSize="12" FontWeight="Bold" Effect="{StaticResource ButtonShadow}"/>
        </StackPanel>
    </Grid>
</Window>
"@

  # Load the XAML into a reader
  $reader = New-Object System.Xml.XmlNodeReader($xaml)
  $window = [Windows.Markup.XamlReader]::Load($reader)

  # Add click actions
  $window.FindName("ReadMeButton").Add_Click({
      Start-Process "firefox" "https://rocketdashboard.notion.site/pwr-windows-Cheat-Sheet-1b8627bc6fd880998e75e7191f8ffffe"
    })


  $window.FindName("UniGetUIButton").Add_Click({
      Start-Process pwsh -ArgumentList @('-File', 'C:\Users\rocket\GitHub-pwr\windows-greeter\button_open_UniGetUI.ps1')
    })

  $window.FindName("ReadMeButton").Add_Click({
      Start-Process "notepad"
    })

  $window.FindName("DirectoriesButton").Add_Click({
      Start-Process "explorer"
    })

  $window.FindName("TitusWinUtilButton").Add_Click({
      Start-Process pwsh -ArgumentList @('-NoProfile', '-Command', '(irm ''https://christitus.com/win'') | iex')
    })

  $window.FindName("ScriptBinButton").Add_Click({
      Start-Process "shell:RecycleBinFolder"
    })

  $window.FindName("MembersOnlyButton").Add_Click({
      Start-Process "control" "ncpa.cpl"
    })

  $window.FindName("ToggleThemeButton").Add_Click({
      # Check the current background color
      if ($window.Background -is [System.Windows.Media.SolidColorBrush] -and `
          $window.Background.Color.ToString() -eq "#FF2B2B2B") {
        # Dark gray in hex (#2B2B2B)

        # Switch to light mode (WhiteSmoke)
        $window.Background = [System.Windows.Media.Brushes]::WhiteSmoke
      }
      else {
        # Switch to dark mode (Custom color #2B2B2B)
        $window.Background = New-Object System.Windows.Media.SolidColorBrush (
          [System.Windows.Media.Color]::FromRgb(43, 43, 43) # RGB equivalent of #2B2B2B
        )
      }
    })


  # Show the window
  $window.ShowDialog()
}