.{
  # Import necessary assemblies
  Add-Type -AssemblyName PresentationFramework

  #* Asset Paths
  $firefoxImagePath = "$env:USERPROFILE\Downloads\windows-greeter\Assets\firefox.png"


  # Load the XAML with enhanced design
  $xaml = [xml]@"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="pwr-greeter"
        Height="700" Width="600"
        Background="#2B2B2B"> <!-- Windows 11-like dark gray -->
    <Window.Resources>
        <!-- Define gradient and shadow styles -->
        <LinearGradientBrush x:Key="ButtonBackground" StartPoint="0,0" EndPoint="1,1">
            <GradientStop Color="#2b2b2b" Offset="0.0"/> <!-- if I want Cyan gradient #00FFFF -->
            <GradientStop Color="#2b2b2b" Offset="1.0"/> <!-- if I want Teal gradient #008B8B -->
        </LinearGradientBrush>
        <DropShadowEffect x:Key="ButtonShadow" BlurRadius="10" ShadowDepth="3" Color="Black" Opacity="0.7"/>

        <!-- Add style for Button -->
        <Style TargetType="Button">
            <Setter Property="Foreground" Value="White"/>
            <Setter Property="FontSize" Value="12"/>
            <Setter Property="FontWeight" Value="Bold"/>
            <Setter Property="Width" Value="260"/>
            <Setter Property="Height" Value="45"/>
            <Setter Property="Margin" Value="0,10,0,0"/>

            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border x:Name="border" Background="{StaticResource ButtonBackground}" Effect="{StaticResource ButtonShadow}">
                            <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                        </Border>
                        <ControlTemplate.Triggers>
                            <Trigger Property="IsMouseOver" Value="True">
                                <Setter Property="Background" Value="Gray" TargetName="border"/>
                            </Trigger>
                        </ControlTemplate.Triggers>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
        </Style>
    </Window.Resources>
    <Grid>
        <Grid.RowDefinitions>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="*"/>
        </Grid.RowDefinitions>

        <Label Grid.Row="0" HorizontalAlignment="Center" VerticalAlignment="Top" Margin="0,10,0,10">
            <TextBlock Text="🚀⚡ Welcome to the Power Greeter ⚡🚀" Foreground="Gold" FontSize="20" FontWeight="Bold" Effect="{StaticResource ButtonShadow}"/>
        </Label>

        <StackPanel Grid.Row="1" Orientation="Vertical" HorizontalAlignment="Center">
            <Button x:Name="ReadMeButton" ToolTip="Open the ReadMe documentation.">
                <StackPanel Orientation="Horizontal">
                    <Image Width="20" Height="20" Margin="5,0,10,0"
                            Source="file:///$firefoxImagePath"/>
                    <TextBlock Text="ReadMe" VerticalAlignment="Center"/>
                </StackPanel>
            </Button>
            <Button x:Name="UniGetUIButton" Content="📦 UniGetUI + Bundles"/>
            <Button x:Name="DotfilesButton" Content="📝 Dotfiles"/>
            <Button x:Name="DirectoriesButton" Content="📁 Directories"/>
            <Button x:Name="TitusWinUtilButton" Content="💻 Titus WinUtil"/>
            <Button x:Name="ScriptBinButton" Content="🗑️ Script Bin"/>
            <Button x:Name="MembersOnlyButton" Content="🔒 Members Only"/>
            <Button x:Name="ToggleThemeButton" Content="🌗 Toggle Dark/Light Mode"/>
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

  $window.FindName("DotfilesButton").Add_Click({
      Start-Process "notepad"
    })

  $window.FindName("DirectoriesButton").Add_Click({
      Start-Process "explorer"
    })

  $window.FindName("TitusWinUtilButton").Add_Click({
      Start-Process pwsh -ArgumentList @('-NoProfile', '-Command', '(irm ''https://christitus.com/win'') | iex')
    })

  $window.FindName("ScriptBinButton").Add_Click({
      Start-Process pwsh -ArgumentList @('-File', 'C:\Users\rocket\GitHub-pwr\windows-greeter\button_open_ScriptBin.ps1')
    })

  $window.FindName("MembersOnlyButton").Add_Click({
      Start-Process "control" "ncpa.cpl"
    })

  $window.FindName("ToggleThemeButton").Add_Click({
      # Check the current background color
      if ($window.Background -is [System.Windows.Media.SolidColorBrush] -and `
          $window.Background.Color.ToString() -eq "#FF2B2B2B") {

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