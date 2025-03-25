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
                    <Button x:Name="HamburgerMenuButton" Content="☰" Style="{StaticResource ToolbarButton}" ToolTip="Menu">
                        <Button.ContextMenu>
                            <ContextMenu>
                                <MenuItem Header="🌗 Toggle Dark/Light Mode" x:Name="ToggleThemeMenuItem"/>
                                <MenuItem Header="ℹ️ About" x:Name="AboutMenuItem"/>
                            </ContextMenu>
                        </Button.ContextMenu>
                    </Button>
                    <Button x:Name="MinimizeButton" Content="_" Style="{StaticResource ToolbarButton}"/>
                    <Button x:Name="CloseButton" Content="X" Style="{StaticResource ToolbarButton}"/>
                </StackPanel>
            </Grid>
        </Border>
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

# Add click actions for menu items
$window.FindName("ToggleThemeMenuItem").Add_Click({
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

$window.FindName("AboutMenuItem").Add_Click({
    # Create a new window for the About dialog
    $aboutWindow = New-Object System.Windows.Window
    $aboutWindow.Title = "About"
    $aboutWindow.Width = 300
    $aboutWindow.Height = 150
    $aboutWindow.WindowStartupLocation = "CenterOwner"
    $aboutWindow.Background = [System.Windows.Media.Brushes]::WhiteSmoke

    # Create a Grid for the About window
    $aboutGrid = New-Object System.Windows.Controls.Grid
    $aboutWindow.Content = $aboutGrid

    # Add a TextBlock with the version information
    $aboutText = New-Object System.Windows.Controls.TextBlock
    $aboutText.Text = "Power Greeter v1.0.0" # Replace with your version number
    $aboutText.FontSize = 16
    $aboutText.FontWeight = "Bold"
    $aboutText.HorizontalAlignment = "Center"
    $aboutText.VerticalAlignment = "Center"
    $aboutGrid.Children.Add($aboutText)

    # Show the About window
    $aboutWindow.ShowDialog()
  })

# Show the window
$window.ShowDialog()
