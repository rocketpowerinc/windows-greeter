<#
.SYNOPSIS
A custom greeter window using WPF.

.DESCRIPTION
This script creates a custom greeter window using WPF, providing a user interface with various buttons for launching applications and utilities. It features a dark theme, custom toolbar, and draggable window. It also includes a hamburger menu with "About" and "Toggle Theme" options. The "About" window now opens in the center and displays the repository website.

.NOTES
* Requires the PresentationFramework assembly.
* Assumes the existence of certain files and directories at specified paths.  These need to be updated if the script is moved.
* Uses PowerShell 7 or later for the -ArgumentList parameter with Start-Process for more reliable argument passing.

.EXAMPLE
.\greeter.ps1

Launches the greeter window.
#>
#Requires -Version 5.1  # Minimum required PowerShell version

try {
  # Import necessary assemblies
  Add-Type -AssemblyName PresentationFramework

  #* Asset Paths - Consider making these configurable or relative to the script's location
  $firefoxImagePath = Join-Path $PSScriptRoot "Assets\firefox.png" #Relative path
  #$firefoxImagePath = "$env:USERPROFILE\Downloads\windows-greeter\Assets\firefox.png" #Original, absolute path.

  # Define Version and Repository URL
  $version = "1.0.0" # Replace with your actual version
  $repoUrl = "https://github.com/rocketpowerinc"

  # Load the XAML with a custom dark toolbar and no native title bar
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
          <Setter Property="FontSize" Value="12"/> <!-- Match button font size -->
          <Setter Property="FontWeight" Value="Bold"/> <!-- Match button font weight -->
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
          <Button x:Name="PersisantWindowsButton" Grid.Column="1" Grid.Row="3" Content="🪟 Persistant Windows" Margin="10" FontFamily="Segoe UI Emoji"/>
          <Button x:Name="ServersButton" Grid.Column="0" Grid.Row="4" Foreground="DodgerBlue"><Button.Content> Content="🐳 Servers" Margin="10"/>
      </Grid>
  </Grid>
</Window>
"@

  # Load the XAML into a reader
  $reader = New-Object System.Xml.XmlNodeReader ($xaml.DocumentElement)
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
      try {
        Start-Process "firefox" "https://rocketdashboard.notion.site/Welcome-to-RocketPowerInc-1a1627bc6fd8805ab693f164a1b3ceda"
      }
      catch {
        Write-Warning "Failed to open Firefox.  Is Firefox installed?"
      }

    })

  $UniGetUIPath = Join-Path $PSScriptRoot "button_open_UniGetUI.ps1"
  $window.FindName("UniGetUIButton").Add_Click({
      if (Test-Path $UniGetUIPath) {
        Start-Process pwsh -ArgumentList @('-File', $UniGetUIPath)
      }
      else {
        Write-Warning "UniGetUI script not found at '$UniGetUIPath'."
      }

    })

  $DotfilesMenuPath = Join-Path $PSScriptRoot "button_dotfiles_menu.ps1"
  $window.FindName("DotfilesButton").Add_Click({
      # Store the root Grid of the main menu
      $global:MainMenuGrid = $window.Content
      # Reference the variable above to suppress vscode warning (optional)
      [void]$global:MainMenuGrid

      # Call the Dotfiles menu script
      if (Test-Path $DotfilesMenuPath) {
        & $DotfilesMenuPath
      }
      else {
        Write-Warning "Dotfiles menu script not found at '$DotfilesMenuPath'."
      }
    })


  $window.FindName("DirectoriesButton").Add_Click({
      Start-Process "explorer"
    })

  $window.FindName("TitusWinUtilButton").Add_Click({
      #Consider using Invoke-WebRequest instead of irm, and add better error handling.
      Start-Process pwsh -ArgumentList @('-NoProfile', '-Command', '(irm ''https://christitus.com/win'') | iex')
    })

  $ScriptBinPath = Join-Path $PSScriptRoot "button_open_ScriptBin.ps1"
  $window.FindName("ScriptBinButton").Add_Click({
      if (Test-Path $ScriptBinPath) {
        Start-Process pwsh -ArgumentList @('-File', $ScriptBinPath)
      }
      else {
        Write-Warning "ScriptBin script not found at '$ScriptBinPath'."
      }
    })

  $window.FindName("MembersOnlyButton").Add_Click({
      Write-Host "Members Only functionality not implemented."
      #TODO: Implement members only functionality
    })


  $PersistantWindowsPath = Join-Path $PSScriptRoot "button_persistant_windows.ps1"
  $window.FindName("PersisantWindowsButton").Add_Click({
      if (Test-Path $PersistantWindowsPath) {
        Start-Process pwsh -ArgumentList @('-File', $PersistantWindowsPath)
      }
      else {
        Write-Warning "Persistent Windows script not found at '$PersistantWindowsPath'."
      }

    })

    $window.FindName("ServersButton").Add_Click({
      Write-Host "Servers baby."
      #TODO: Implement members only functionality
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
      $aboutWindow.Width = 400  # Increased width for the link
      $aboutWindow.Height = 200 # Increased height for the link and spacing
      $aboutWindow.WindowStartupLocation = "CenterOwner" #This works with ShowDialog()
      $aboutWindow.Owner = $window # Set the owner to center relative to the main window
      $aboutWindow.Background = New-Object System.Windows.Media.SolidColorBrush([System.Windows.Media.Color]::FromRgb(43, 43, 43)) # Use the same dark background

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


  # Show the window
  $window.ShowDialog()

}
catch {
  Write-Error "An error occurred: $($_.Exception.Message)"
  Write-Error $_.Exception.StackTrace
}
finally {
  #Optional cleanup
}