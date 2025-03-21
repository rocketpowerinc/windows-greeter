.{
  # Import necessary assemblies
  Add-Type -AssemblyName PresentationFramework

  #* Asset Paths
  $firefoxImagePath = "$env:USERPROFILE\Downloads\windows-greeter\Assets\firefox.png"

  # Load the XAML with a custom dark toolbar and no native title bar
  $xaml = [xml]@"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="pwr-greeter"
        Height="700" Width="600"
        Background="#2B2B2B"
        WindowStyle="None"
        ResizeMode="CanResizeWithGrip"
        AllowsTransparency="True">
    <Window.Resources>
        <LinearGradientBrush x:Key="ButtonBackground" StartPoint="0,0" EndPoint="1,1">
            <GradientStop Color="#2b2b2b" Offset="0.0"/>
            <GradientStop Color="#2b2b2b" Offset="1.0"/>
        </LinearGradientBrush>
        <DropShadowEffect x:Key="ButtonShadow" BlurRadius="10" ShadowDepth="3" Color="Black" Opacity="0.7"/>
        <LinearGradientBrush x:Key="ToolbarBackground" StartPoint="0,0" EndPoint="0,1">
            <GradientStop Color="#1F1F1F" Offset="0.0"/>
            <GradientStop Color="#2B2B2B" Offset="1.0"/>
        </LinearGradientBrush>
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
        <Style x:Key="ToolbarButton" TargetType="Button">
            <Setter Property="Foreground" Value="White"/>
            <Setter Property="Background" Value="Transparent"/>
            <Setter Property="BorderThickness" Value="0"/>
            <Setter Property="Width" Value="30"/>
            <Setter Property="Height" Value="20"/>
            <Setter Property="Margin" Value="2,0,2,0"/>
            <Setter Property="VerticalAlignment" Value="Center"/>
        </Style>
    </Window.Resources>
    <Grid Margin="0">
        <Grid.RowDefinitions>
            <RowDefinition Height="40"/>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="*"/>
        </Grid.RowDefinitions>
        <Border Grid.Row="0" Background="{StaticResource ToolbarBackground}" BorderBrush="#3C3C3C" BorderThickness="0,0,0,1">
            <Grid>
                <Grid.ColumnDefinitions>
                    <ColumnDefinition Width="*"/>
                    <ColumnDefinition Width="Auto"/>
                </Grid.ColumnDefinitions>
                <TextBlock Grid.Column="0" Text="pwr-greeter" Foreground="White" FontSize="14" FontWeight="SemiBold" VerticalAlignment="Center" Margin="10,0,0,0"/>
                <StackPanel Grid.Column="1" Orientation="Horizontal" HorizontalAlignment="Right" VerticalAlignment="Center" Margin="0,0,10,0">
                    <Button x:Name="MinimizeButton" Content="_" Style="{StaticResource ToolbarButton}"/>
                    <Button x:Name="CloseButton" Content="X" Style="{StaticResource ToolbarButton}"/>
                </StackPanel>
            </Grid>
        </Border>
        <Label Grid.Row="1" HorizontalAlignment="Center" VerticalAlignment="Top" Margin="0,10,0,10">
            <TextBlock Text="Rocket Power Greeter: Batteries included (Windows Edition)" Foreground="Blue" FontSize="20" FontWeight="Bold" Effect="{StaticResource ButtonShadow}"/>
        </Label>
        <StackPanel Grid.Row="2" Orientation="Vertical" HorizontalAlignment="Center">
            <Button x:Name="ReadMeButton" ToolTip="Open the ReadMe documentation.">
                <StackPanel Orientation="Horizontal">
                    <Image Width="20" Height="20" Margin="5,0,10,0" Source="file:///$firefoxImagePath"/>
                    <TextBlock Text="ReadMe" VerticalAlignment="Center"/>
                </StackPanel>
            </Button>
            <Button x:Name="UniGetUIButton" Content="📦 UniGetUI + Bundles"/>
            <Button x:Name="DotfilesButton" Content="📝 Dotfiles"/>
            <Button x:Name="DirectoriesButton" Content="📁 Directories"/>
            <Button x:Name="TitusWinUtilButton" Content="💻 Titus WinUtil"/>
            <Button x:Name="ScriptBinButton" Content="🗑️ Script Bin"/>
            <Button x:Name="MembersOnlyButton" Content="🔒 Members Only"/>
            <Button x:Name="PersisantWindowsButton" Content="🔒 Persistant Windows"/>
            <Button x:Name="ToggleThemeButton" Content="🌗 Toggle Dark/Light Mode"/>
        </StackPanel>
    </Grid>
</Window>
"@

  # Load the XAML into a reader
  $reader = New-Object System.Xml.XmlNodeReader($xaml)
  $window = [Windows.Markup.XamlReader]::Load($reader)

  # Enable dragging the window by the toolbar
  $window.Add_MouseLeftButtonDown({
      $window.DragMove()
    })

  # Add click actions for toolbar buttons
  $window.FindName("MinimizeButton").Add_Click({
      $window.WindowState = [System.Windows.WindowState]::Minimized
    })

  $window.FindName("CloseButton").Add_Click({
      $window.Close()
    })

  # Add click actions for main buttons
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
      write-host "Members Only"
    })

  $window.FindName("PersisantWindowsButton").Add_Click({
      Start-Process pwsh -ArgumentList @('-File', (Join-Path $PSScriptRoot 'button_persistant_windows.ps1'))
    })

  $window.FindName("ToggleThemeButton").Add_Click({
      if ($window.Background -is [System.Windows.Media.SolidColorBrush] -and `
          $window.Background.Color.ToString() -eq "#FF2B2B2B") {
        $window.Background = [System.Windows.Media.Brushes]::WhiteSmoke
      }
      else {
        $window.Background = New-Object System.Windows.Media.SolidColorBrush (
          [System.Windows.Media.Color]::FromRgb(43, 43, 43) # RGB equivalent of #2B2B2B
        )
      }
    })

  # Show the window
  $window.ShowDialog()
}