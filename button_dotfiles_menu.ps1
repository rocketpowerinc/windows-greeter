# Import necessary assemblies
Add-Type -AssemblyName PresentationFramework

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
            <TextBlock Text="🚀⚡ Welcome to the Power Greeter ⚡🚀" Foreground="Gold" FontSize="20" FontWeight="Bold" Effect="{StaticResource ButtonShadow}"/>
        </Label>
        <TextBlock Grid.Row="1" HorizontalAlignment="Center" VerticalAlignment="Top" Margin="0,50,0,0"
            Text="Windows Edition" Foreground="#0078D7" FontSize="16" FontWeight="SemiBold"/>
        <Grid Grid.Row="2" HorizontalAlignment="Center" Margin="0,20,0,0">
            <Grid.ColumnDefinitions>
                <ColumnDefinition Width="*"/>
                <ColumnDefinition Width="*"/>
            </Grid.ColumnDefinitions>
            <Grid.RowDefinitions>
                <RowDefinition Height="Auto"/>
                <RowDefinition Height="Auto"/>
            </Grid.RowDefinitions>
            <!-- New Buttons -->
            <Button x:Name="CopyProfileButton" Grid.Column="0" Grid.Row="0" Content="📋 Copy PowerShell Profile" Margin="10"/>
            <Button x:Name="WSLDotfileButton" Grid.Column="1" Grid.Row="0" Content="🖥️ WSL Bash Dotfile" Margin="10"/>
        </Grid>
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

#*########################    DOTFILE FUNCTIONS      #########################
$window.FindName("CopyProfileButton").Add_Click({
    Write-Host "Place Holder"
  })

$window.FindName("WSLDotfileButton").Add_Click({
    Write-Host "Place Holder"
  })

# Show the window
$window.ShowDialog()
