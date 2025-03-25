<#
.SYNOPSIS
A custom greeter window using WPF.

.DESCRIPTION
This script creates a custom greeter window using WPF, providing a user interface with various buttons for launching applications and utilities.

.NOTES
* Requires the PresentationFramework assembly.
* Assumes the existence of certain files and directories at specified paths.
* Uses PowerShell 7 or later for the -ArgumentList parameter with Start-Process for more reliable argument passing.

.EXAMPLE
.\greeter.ps1

Launches the greeter window.
#>

#Requires -Version 5.1

try {
  # Import necessary assemblies
  Add-Type -AssemblyName PresentationFramework

  # Configuration Section
  $version = "1.0.0"
  $repoUrl = "https://github.com/rocketpowerinc"

  # Function to get script path
  function Get-ScriptPath {
    param (
      [string]$FileName
    ) {
      return Join-Path $PSScriptRoot $FileName
    }
  }

  # Define file paths using the function
  $firefoxImagePath = Get-ScriptPath -FileName "Assets\firefox.png"
  $UniGetUIPath = Get-ScriptPath -FileName "button_open_UniGetUI.ps1"
  $DotfilesMenuPath = Get-ScriptPath -FileName "button_dotfiles_menu.ps1"
  $ScriptBinPath = Get-ScriptPath -FileName "button_open_ScriptBin.ps1"
  $PersistantWindowsPath = Get-ScriptPath -FileName "button_persistant_windows.ps1"

  # Load XAML (consider externalizing to a file for easier editing)
  $xaml = [xml]@"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
    Title="pwr-greeter"
    Height="700" Width="600"
    Background="#2B2B2B"
    WindowStyle="None"
    ResizeMode="CanResizeWithGrip"
    AllowsTransparency="True"
    WindowStartupLocation="CenterScreen">  <!-- Added to center the window -->
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
          <Setter Property="Cursor" Value="Hand"/> <!-- Added to indicate clickable buttons -->
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
          <Setter Property="Cursor" Value="Hand"/> <!-- Added for toolbar buttons -->
      </Style>

      <!-- Style for Menu Items -->
      <Style TargetType="MenuItem">
          <Setter Property="Foreground" Value="White"/>
          <Setter Property="Background" Value="#2B2B2B"/>
          <Setter Property="BorderThickness" Value="0"/>
          <Setter Property="Padding" Value="5"/>
      </Style>

      <!-- Style for the Menu itself -->
      <Style TargetType="Menu">
          <Setter Property="Background" Value="#1F1F1F"/>
          <Setter Property="BorderThickness" Value="0"/>
      </Style>

  </Window.Resources>
  <Grid Margin="0">
      <Grid.RowDefinitions>
          <RowDefinition Height="40"/>
          <RowDefinition Height="Auto"/>
          <RowDefinition Height="*"/>
      </Grid.RowDefinitions>

      <!-- Toolbar -->
      <Border Grid.Row="0" Background="{StaticResource ToolbarBackground}" BorderBrush="#3C3C3C" BorderThickness="0,0,0,1">
          <Grid>
              <Grid.ColumnDefinitions>
                  <ColumnDefinition Width="Auto"/>
                  <ColumnDefinition Width="*"/>
                  <ColumnDefinition Width="Auto"/>
              </Grid.ColumnDefinitions>

              <!-- Hamburger Menu -->
              <Menu Grid.Column="0" VerticalAlignment="Center">
                  <MenuItem Header="☰" Foreground="White" FontSize="16" FontWeight="Bold">
                      <MenuItem x:Name="ToggleThemeMenuItem" Header="Toggle Theme"/>
                      <MenuItem x:Name="AboutMenuItem" Header="About"/>
                  </MenuItem>
              </Menu>

              <TextBlock Grid.Column="1" Text="pwr-greeter" Foreground="White" FontSize="14" FontWeight="SemiBold" VerticalAlignment="Center" Margin="10,0,0,0"/>
              <StackPanel Grid.Column="2" Orientation="Horizontal" HorizontalAlignment="Right" VerticalAlignment="Center" Margin="0,0,10,0">
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
              <RowDefinition Height="Auto"/>
              <RowDefinition Height="Auto"/>
              <RowDefinition Height="Auto"/>
          </Grid.RowDefinitions>
          <Button x:Name="ReadMeButton" Grid.Column="0" Grid.Row="0" ToolTip="Open the ReadMe documentation." Margin="10">
              <StackPanel Orientation="Horizontal">
                  <Image Width="20" Height="20" Margin="5,0,10,0" Source="file:///$firefoxImagePath"/>
                  <TextBlock Text="ReadMe" VerticalAlignment="Center"/>
              </StackPanel>
          </Button>
          <Button x:Name="UniGetUIButton" Grid.Column="1" Grid.Row="0" Content="📦 UniGetUI + Bundles" Margin="10"/>
          <Button x:Name="DotfilesButton" Grid.Column="0" Grid.Row="1" Content="📂 Dotfiles" Margin="10"/>
          <Button x:Name="DirectoriesButton" Grid.Column="1" Grid.Row="1" Content="📁 Directories" Margin="10"/>
          <Button x:Name="TitusWinUtilButton" Grid.Column="0" Grid.Row="2" Content="💻 Titus WinUtil" Margin="10"/>
          <Button x:Name="ScriptBinButton" Grid.Column="1" Grid.Row="2" Content="🗑️ Script Bin" Margin="10"/>
          <Button x:Name="MembersOnlyButton" Grid.Column="0" Grid.Row="3" Content="🔒 Members Only" Margin="10"/>
          <Button x:Name="PersistantWindowsButton" Grid.Column="1" Grid.Row="3" Content="🪟 Persistant Windows" Margin="10" FontFamily="Segoe UI Emoji"/>
      </Grid>
  </Grid>
</Window>
"@

  # Load the XAML into a reader
  $reader = New-Object System.Xml.XmlNodeReader($xaml.DocumentElement)
  $window = [Windows.Markup.XamlReader]::Load($reader)

  # Event Handlers
  $window.Add_MouseLeftButtonDown({
      $window.DragMove()
    })
  $window.FindName("MinimizeButton").Add_Click({
      $window.WindowState = [System.Windows.WindowState]::Minimized
    })
  $window.FindName("CloseButton").Add_Click({
      $window.Close()
    })

  $window.FindName("ReadMeButton").Add_Click({
      try {
        Start-Process "firefox" "https://rocketdashboard.notion.site/pwr-windows-Cheat-Sheet-1b8627bc6fd880998e75e7191f8ffffe"
      }
      catch {
        Write-Warning "Failed to open Firefox.  Is Firefox installed?"
      }
    })

  $window.FindName("UniGetUIButton").Add_Click({
      try {
        if (Test-Path $UniGetUIPath) {
          Start-Process pwsh -ArgumentList @('-File', $UniGetUIPath)
        }
        else {
          Write-Warning "UniGetUI script not found at '$UniGetUIPath'."
        }
      }
      catch {
        Write-Warning "Failed to start UniGetUI script."
      }
    })

  $window.FindName("DotfilesButton").Add_Click({
      $MainMenuGrid = $window.Content  # Get the grid locally
      try {
        if (Test-Path $DotfilesMenuPath) {
          & $DotfilesMenuPath -MainMenuGrid $MainMenuGrid
        }
        else {
          Write-Warning "Dotfiles menu script not found at '$DotfilesMenuPath'."
        }
      }
      catch {
        Write-Warning "Failed to start Dotfiles menu script."
      }
    })

  $window.FindName("DirectoriesButton").Add_Click({
      try {
        Start-Process "explorer"
      }
      catch {
        Write-Warning "Failed to start Explorer."
      }
    })

  $window.FindName("TitusWinUtilButton").Add_Click({
      try {
        #Using Invoke web request instead of irm.
        $script = Invoke-WebRequest -Uri "https://christitus.com/win" -UseBasicParsing
        Start-Process pwsh -ArgumentList "-NoProfile", "-Command", $script.Content
      }
      catch {
        Write-Warning "Failed to download and run Titus WinUtil."
      }

    })

  $window.FindName("ScriptBinButton").Add_Click({
      try {
        if (Test-Path $ScriptBinPath) {
          Start-Process pwsh -ArgumentList @('-File', $ScriptBinPath)
        }
        else {
          Write-Warning "ScriptBin script not found at '$ScriptBinPath'."
        }
      }
      catch {
        Write-Warning "Failed to start ScriptBin script."
      }
    })

  $window.FindName("MembersOnlyButton").Add_Click({
      Write-Host "Members Only functionality not implemented."
    })

  $window.FindName("PersistantWindowsButton").Add_Click({
      try {
        if (Test-Path $PersistantWindowsPath) {
          Start-Process pwsh -ArgumentList @('-File', $PersistantWindowsPath)
        }
        else {
          Write-Warning "Persistent Windows script not found at '$PersistantWindowsPath'."
        }
      }
      catch {
        Write-Warning "Failed to start Persistent Windows script."
      }
    })

  # Theme Toggle
  $window.FindName("ToggleThemeMenuItem").Add_Click({
      if ($window.Background -is [System.Windows.Media.SolidColorBrush] -and $window.Background.Color.ToString() -eq "#FF2B2B2B") {
        $window.Background = [System.Windows.Media.Brushes]::WhiteSmoke
      }
      else {
        $darkBrush = New-Object System.Windows.Media.SolidColorBrush ([System.Windows.Media.Color]::FromRgb(43, 43, 43))
        $darkBrush.Freeze()  # Freeze the brush
        $window.Background = $darkBrush
      }
    })

  # About Menu Item
  $window.FindName("AboutMenuItem").Add_Click({
      # Create a new window for the About dialog
      $aboutWindow = New-Object System.Windows.Window
      $aboutWindow.Title = "About"
      $aboutWindow.Width = 400  # Increased width for the link
      $aboutWindow.Height = 200 # Increased height for the link and spacing
      $aboutWindow.WindowStartupLocation = "CenterOwner" #This works with ShowDialog()
      $aboutWindow.Owner = $window # Set the owner to center relative to the main window
      $aboutWindow.ResizeMode = "NoResize"
      $aboutWindow.Background = New-Object System.Windows.Media.SolidColorBrush([System.Windows.Media.Color]::FromRgb(43, 43, 43)) # Use the same dark background
      $aboutWindow.Background.Freeze() #Freeze

      # Create a Grid for the About window
      $aboutGrid = New-Object System.Windows.Controls.Grid
      $aboutGrid.Margin = "10" # Add some margin for better spacing
      $aboutWindow.Content = $aboutGrid

      #Row Definitions
      $aboutGrid.RowDefinitions.Add((New-Object System.Windows.Controls.RowDefinition)) #Row 0
      $aboutGrid.RowDefinitions.Add((New-Object System.Windows.Controls.RowDefinition)) #Row 1
      $aboutGrid.RowDefinitions.Add((New-Object System.Windows.Controls.RowDefinition)) #Row 2

      # Add a TextBlock with the version information
      $aboutText = New-Object System.Windows.Controls.TextBlock
      $aboutText.Text = "Power Greeter v$version"  # Include the version
      $aboutText.FontSize = 16
      $aboutText.FontWeight = "Bold"
      $aboutText.Foreground = [System.Windows.Media.Brushes]::White
      $aboutText.HorizontalAlignment = "Center"
      $aboutText.VerticalAlignment = "Center"
      [System.Windows.Controls.Grid]::SetRow($aboutText, 0)
      $aboutGrid.Children.Add($aboutText)

      # Add a TextBlock for the repository URL
      $aboutLink = New-Object System.Windows.Controls.TextBlock
      $aboutLink.Text = "Visit Rocket-Power-Included GitHub Repository"
      $aboutLink.FontSize = 14
      $aboutLink.Foreground = [System.Windows.Media.Brushes]::LightBlue # A color that suggests a link
      $aboutLink.HorizontalAlignment = "Center"
      $aboutLink.VerticalAlignment = "Center"
      $aboutLink.Cursor = "Hand" # Change cursor to a hand
      [System.Windows.Controls.Grid]::SetRow($aboutLink, 1)

      # Add the click event to the link
      $aboutLink.Add_MouseLeftButtonDown({
          try {
            Start-Process "explorer" $repoUrl # Open the URL in the default browser
          }
          catch {
            Write-Warning "Could not open the URL in the browser."
          }

        })

      $aboutGrid.Children.Add($aboutLink)

      # Add a TextBlock with the version information
      $aboutClose = New-Object System.Windows.Controls.Button
      $aboutClose.Content = "Close"  # Include the version
      $aboutClose.FontSize = 14
      $aboutClose.FontWeight = "Bold"
      $aboutClose.Foreground = [System.Windows.Media.Brushes]::White
      $aboutClose.Background = New-Object System.Windows.Media.SolidColorBrush([System.Windows.Media.Color]::FromRgb(43, 43, 43))
      $aboutClose.Background.Freeze() #Freeze
      $aboutClose.HorizontalAlignment = "Center"
      $aboutClose.VerticalAlignment = "Center"
      $aboutClose.Cursor = "Hand" # Change cursor to a hand
      [System.Windows.Controls.Grid]::SetRow($aboutClose, 2)
      $aboutClose.Add_Click({
          $aboutWindow.Close()
        })
      $aboutGrid.Children.Add($aboutClose)

      # Show the About window
      $aboutWindow.ShowDialog()
    })

  # Show the main window
  $window.ShowDialog()

}
catch {
  Write-Error "An error occurred: $($_.Exception.Message)"
  Write-Error $_.Exception.StackTrace
}
finally {
  # Ensure reader is disposed of
  if ($reader) {
    try {
      $reader.Close()
      $reader.Dispose()
    }
    catch {
      Write-Warning "Error disposing of XML reader: $($_.Exception.Message)"
    }
  }
}