# ====================================================================== #
# UTF-8 with BOM Encoding for output
# ====================================================================== #

if ($PSVersionTable.PSVersion.Major -eq 5) {
    $OutputEncoding = [System.Text.Encoding]::UTF8
    [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
    [Console]::InputEncoding = [System.Text.Encoding]::UTF8
} else {
    $utf8WithBom = New-Object System.Text.UTF8Encoding $true
    $OutputEncoding = $utf8WithBom
    [Console]::OutputEncoding = $utf8WithBom
}

# ====================================================================== #
#  Script Metadata
# ====================================================================== #

$Script:WinfigMeta = @{
    Author       = "Armoghan-ul-Mohmin"
    CompanyName  = "Get-Winfig"
    Description  = "Windows configuration and automation framework"
    Version     = "1.0.0"
    License     = "MIT"
    Platform    = "Windows"
    PowerShell  = $PSVersionTable.PSVersion.ToString()
}

# ====================================================================== #
#  Color Palette
# ====================================================================== #

$Script:WinfigColors = @{
    Primary   = "Blue"
    Success   = "Green"
    Info      = "Cyan"
    Warning   = "Yellow"
    Error     = "Red"
    Accent    = "Magenta"
    Light     = "White"
    Dark      = "DarkGray"
}

# ====================================================================== #
# User Prompts
# ====================================================================== #

$Script:WinfigPrompts = @{
    Confirm    = "[?] Do you want to proceed? (Y/N): "
    Retry      = "[?] Do you want to retry? (Y/N): "
    Abort      = "[!] Operation aborted by user."
    Continue   = "[*] Press any key to continue..."
}

# ====================================================================== #
#  Paths
# ====================================================================== #

$Global:WinfigPaths = @{
    Desktop         = [Environment]::GetFolderPath("Desktop")
    Documents       = [Environment]::GetFolderPath("MyDocuments")
    UserProfile     = [Environment]::GetFolderPath("UserProfile")
    Temp            = [Environment]::GetEnvironmentVariable("TEMP")
    AppDataRoaming  = [Environment]::GetFolderPath("ApplicationData")
    AppDataLocal    = [Environment]::GetFolderPath("LocalApplicationData")
    Downloads       = [System.IO.Path]::Combine([Environment]::GetFolderPath("UserProfile"), "Downloads")
    Logs            = [System.IO.Path]::Combine([Environment]::GetEnvironmentVariable("TEMP"), "Winfig-Logs")
}
$Global:WinfigPaths.DotFiles = [System.IO.Path]::Combine($Global:WinfigPaths.UserProfile, ".Dotfiles")

$profilesPath = [System.IO.Path]::Combine($Global:WinfigPaths.AppDataRoaming, "Zen", "Profiles")
$default = $null
if (Test-Path $profilesPath) {
    $profileFolders = Get-ChildItem -Path $profilesPath -Directory | Where-Object { $_.Name -like '*Default*' -and $_.Name -like '*(release)*' }
    if ($profileFolders.Count -gt 0) {
        $default = $profileFolders[0].Name
    }
}
$Global:WinfigPaths.zenProfile = [System.IO.Path]::Combine($profilesPath, $default)
$Global:WinfigPaths.zenChrome = [System.IO.Path]::Combine($profilesPath, $default, "chrome")

# ===================================================================== #
#  Zen Mods
# ===================================================================== #
$Script:ZenMods = @(
    @{ url = "zen-browser.app/mods/4596d8f9-f0b7-4aeb-aa92-851222dc1888"; Name = "Close On Hover"; Description = "Closes tabs when you hover over the close button for a smoother workflow." }
    @{ url = "zen-browser.app/mods/b0f635d7-c3bf-4709-af68-4712f0e5b2e5/?page=2"; Name = "Cleaner Bookmark Menu"; Description = "Improves the appearance and usability of the bookmarks menu." }
    @{ url = "zen-browser.app/mods/e122b5d9-d385-4bf8-9971-e137809097d0/?page=3"; Name = "No Top Sites"; Description = "Removes or hides the Top Sites section from the new tab page for a cleaner look." }
    @{ url = "zen-browser.app/mods/e74cb40a-f3b8-445a-9826-1b1b6e41b846/?page=3"; Name = "Custom uiFont"; Description = "Lets you set a custom font for the Zen browser UI for a personalized experience." }
    @{ url = "zen-browser.app/mods/e51b85e6-cef5-45d4-9fff-6986637974e1/?page=5"; Name = "smaller zen toast popup"; Description = "Reduces the size of toast popups for less intrusive notifications." }
    @{ url = "zen-browser.app/mods/d8b79d4a-6cba-4495-9ff6-d6d30b0e94fe/?q=Active"; Name = "Better Active Tab"; Description = "Enhances the appearance and visibility of the active tab." }
    @{ url = "zen-browser.app/mods/253a3a74-0cc4-47b7-8b82-996a64f030d5/?q=history"; Name = "Clean History Panel"; Description = "Floating History Panel for easier access and management." }
    @{ url = "zen-browser.app/mods/6cd4bca9-f17d-4461-b554-844d69a4887c"; Name = "Better Exit Buttons"; Description = "Improves the design and functionality of the exit buttons for a better user experience." }
    @{ url = "zen-browser.app/mods/906c6915-5677-48ff-9bfc-096a02a72379"; Name = "Floating Status Bar"; Description = "Mod for Zen Browser that detaches the status bar from the bottom left corner of the browser window." }
    @{ url = "zen-browser.app/mods/c8d9e6e6-e702-4e15-8972-3596e57cf398/?page=6"; Name = "Zen Back Forward"; Description = "Show Forward and backword buttons only when available." }
    @{ url = "zen-browser.app/mods/ea1a5ace-f698-4b45-ab88-6e8bd3a563f0/?q=bookmarks"; Name = "Bookmark Toolbar"; Description = "Comprehensive bookmarks toolbar customization: center, hide icons, transparent backgrounds, auto-hide with hover/search expand"}
)

# ===================================================================== #
#  Sine Mods
# ===================================================================== #
$Script:SineMods = @(
    @{ url = "Vertex-Mods/Zen-Tidy-Downloads"; Name = "Zen Tidy Downloads"; Description = "Rename your downloads with ease, and do it in style"; file = "chrome.css" }
    @{ url = "themaster5209/zen-better-new-tab-button"; Name = "Better New Tab"; Description = "A Zen Browser mod that enhances the New Tab button experience"; file = "userChrome.css" }
    @{ url = "qumeqa/floating-statusbar"; Name = "Floating Statusbar"; Description = "A Zen Mod that provides a floating status bar for better visibility and accessibility"; file = "userChrome.css" }
    @{ url = "rasyidrafi/zen-always-show-music-bar"; Name = "Show Music Bar"; Description = "enhances the music bar with always-visible controls, custom backgrounds, and improved usability"; file = "chrome.css" }
    @{ url = "qumeqa/zen-icons"; Name = "Zen Icons"; Description = "New icons for the toolbar and better locale button"; file = "userChrome.css" }
    @{ url = "qumeqa/floating-findbar"; Name = "Floating Findbar"; Description = "A floating findbar with opening and closing animation"; file = "userChrome.css" }
    @{ url = "rasyidrafi/zen-better-sidebar"; Name = "Better Sidebar"; Description = "Enhances the default sidebar with a sleek, modern look"; file = "chrome.css" }
    @{ url = "rasyidrafi/zen-custom-urlbar"; Name = "Custom URL Bar"; Description = "Customizes the URL bar for a better browsing experience"; file = "chrome.css" }
)

# ====================================================================== #
# Start Time, Resets, Counters
# ====================================================================== #
$Global:WinfigLogStart = Get-Date
$Global:WinfigLogFilePath = $null
Remove-Variable -Name WinfigLogFilePath -Scope Global -ErrorAction SilentlyContinue
Remove-Variable -Name LogCount -Scope Global -ErrorAction SilentlyContinue
Remove-Variable -Name ErrorCount -Scope Global -ErrorAction SilentlyContinue
Remove-Variable -Name WarnCount -Scope Global -ErrorAction SilentlyContinue

# ====================================================================== #
# Utility Functions
# ====================================================================== #

# ---------------------------------------------------------------------------- #
# Function to display a Success message
function Show-SuccessMessage {
    param (
        [string]$Message
    )
    Write-Host "[OK] $Message" -ForegroundColor $Script:WinfigColors.Success
}

# ---------------------------------------------------------------------------- #
# Function to display an Error message
function Show-ErrorMessage {
    param (
        [string]$Message
    )
    Write-Host "[ERROR] $Message" -ForegroundColor $Script:WinfigColors.Error
}

# ---------------------------------------------------------------------------- #
# Function to display an Info message
function Show-InfoMessage {
    param (
        [string]$Message
    )
    Write-Host "[INFO] $Message" -ForegroundColor $Script:WinfigColors.Info
}

# ---------------------------------------------------------------------------- #
# Function to display a Warning message
function Show-WarningMessage {
    param (
        [string]$Message
    )
    Write-Host "[WARN] $Message" -ForegroundColor $Script:WinfigColors.Warning
}

# ---------------------------------------------------------------------------- #
# Function to prompt user for input with a specific color
function Prompt-UserInput {
    param (
        [string]$PromptMessage = $Script:WinfigPrompts.Confirm,
        [string]$PromptColor   = $Script:WinfigColors.Primary
    )
    # Write prompt in the requested color, keep cursor on same line, then read input
    Write-Host -NoNewline $PromptMessage -ForegroundColor $PromptColor
    $response = Read-Host

    return $response
}

# ---------------------------------------------------------------------------- #
# Function to Prompt user for confirmation (Y/N)
function Prompt-UserConfirmation {
    while ($true) {
        $response = Prompt-UserInput -PromptMessage $Script:WinfigPrompts.Confirm -PromptColor $Script:WinfigColors.Primary
        switch ($response.ToUpper()) {
            "Y" { return $true }
            "N" { return $false }
            default {
                Show-WarningMessage "Invalid input. Please enter Y or N."
            }
        }
    }
}

# ---------------------------------------------------------------------------- #
# Function to Prompt user to Retry (Y/N)
function Prompt-UserRetry {
    while ($true) {
        $response = Prompt-UserInput -PromptMessage $Script:WinfigPrompts.Retry -PromptColor $Script:WinfigColors.Primary
        switch ($response.ToUpper()) {
            "Y" { return $true }
            "N" { return $false }
            default {
                Show-WarningMessage "Invalid input. Please enter Y or N."
            }
        }
    }
}

# ---------------------------------------------------------------------------- #
# Function to Prompt user to continue
function Prompt-UserContinue {
    Write-Host $Script:WinfigPrompts.Continue -ForegroundColor $Script:WinfigColors.Primary
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

# ---------------------------------------------------------------------------- #
# Function to Abort operation
function Abort-Operation {
    Show-ErrorMessage $Script:WinfigPrompts.Abort
    # Write log footer before exiting
    if ($Global:WinfigLogFilePath) {
        Log-Message -Message "Script terminated." -EndRun
    }
    exit 1
}

# ---------------------------------------------------------------------------- #
# Function to Write a Section Header
function Write-SectionHeader {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Title,

        [Parameter(Mandatory=$false)]
        [string]$Description = ""
    )
    $separator = "=" * 70
    Write-Host $separator -ForegroundColor $Script:WinfigColors.Accent
    Write-Host "$Title" -ForegroundColor $Script:WinfigColors.Primary
    if ($Description) {
        Write-Host "$Description" -ForegroundColor $Script:WinfigColors.Accent
    }
    Write-Host $separator -ForegroundColor $Script:WinfigColors.Accent
}

# ---------------------------------------------------------------------------- #
# Function to Write a Subsection Header
function Write-SubsectionHeader {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Title
    )
    $separator = "-" * 50
    Write-Host $separator -ForegroundColor $Script:WinfigColors.Accent
    Write-Host "$Title" -ForegroundColor $Script:WinfigColors.Primary
    Write-Host $separator -ForegroundColor $Script:WinfigColors.Accent
}

# ---------------------------------------------------------------------------- #
#  Function to Write a Log Message
function Log-Message {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Message,

        [Parameter(Mandatory=$false)]
        [ValidateSet("DEBUG", "INFO", "WARN", "ERROR", "SUCCESS")]
        [string]$Level = "INFO",

        [Parameter(Mandatory=$false)]
        [switch]$EndRun
    )

    if (-not $Global:LogCount) { $Global:LogCount = 0 }
    if (-not $Global:ErrorCount) { $Global:ErrorCount = 0 }
    if (-not $Global:WarnCount) { $Global:WarnCount = 0 }


    if (-not (Test-Path -Path $Global:WinfigPaths.Logs)) {
        New-Item -ItemType Directory -Path $Global:WinfigPaths.Logs -Force | Out-Null
    }

    $enc = New-Object System.Text.UTF8Encoding $true

    $identity = try { [System.Security.Principal.WindowsIdentity]::GetCurrent().Name } catch { $env:USERNAME }
    $isElevated = try {
        (New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    } catch {
        $false
    }
    $scriptPath = if ($PSCommandPath) { $PSCommandPath } elseif ($MyInvocation.MyCommand.Path) { $MyInvocation.MyCommand.Path } else { $null }
    $psVersion = $PSVersionTable.PSVersion.ToString()
    $dotNetVersion = [System.Environment]::Version.ToString()
    $workingDir = (Get-Location).Path
    $osInfo = try {
        (Get-CimInstance -ClassName Win32_OperatingSystem -ErrorAction Stop).Caption
    } catch {
        [Environment]::OSVersion.VersionString
    }
    # ---------------------------------------------------------------------------------------

    if (-not $Global:WinfigLogFilePath) {
        # $Global:WinfigLogStart is set in the main script execution block for each run
        $fileStamp = $Global:WinfigLogStart.ToString('yyyy-MM-dd_HH-mm-ss')
        $Global:WinfigLogFilePath = [System.IO.Path]::Combine($Global:WinfigPaths.Logs, "winfig-Dotfiles-$fileStamp.log")

        $header = @()
        $header += "==================== Winfig Dotfiles Log ===================="
        $header += "Start Time  : $($Global:WinfigLogStart.ToString('yyyy-MM-dd HH:mm:ss'))"
        $header += "Host Name   : $env:COMPUTERNAME"
        $header += "User        : $identity"
        $header += "IsElevated  : $isElevated"
        if ($scriptPath) { $header += "Script Path : $scriptPath" }
        $header += "Working Dir : $workingDir"
        $header += "PowerShell  : $psVersion"
        $header += "NET Version : $dotNetVersion"
        $header += "OS          : $osInfo"
        $header += "=============================================================="
        $header += ""

        try {
            [System.IO.File]::WriteAllLines($Global:WinfigLogFilePath, $header, $enc)
        } catch {
            $header | Out-File -FilePath $Global:WinfigLogFilePath -Encoding UTF8 -Force
        }
    } else {
        if (-not $Global:WinfigLogStart) {
            $Global:WinfigLogStart = Get-Date
        }

        try {
            if (Test-Path -Path $Global:WinfigLogFilePath) {
                $firstLine = Get-Content -Path $Global:WinfigLogFilePath -TotalCount 1 -ErrorAction SilentlyContinue
                if ($firstLine -and ($firstLine -notmatch 'Winfig Dotfiles Log')) {

                    $header = @()
                    $header += "==================== Winfig Dotfiles Log  ===================="
                    $header += "Start Time  : $($Global:WinfigLogStart.ToString('yyyy-MM-dd HH:mm:ss'))"
                    $header += "Host Name   : $env:COMPUTERNAME"
                    $header += "User        : $identity"
                    $header += "IsElevated  : $isElevated"
                    if ($scriptPath) { $header += "Script Path : $scriptPath" }
                    $header += "Working Dir : $workingDir"
                    $header += "PowerShell  : $psVersion"
                    $header += "NET Version : $dotNetVersion"
                    $header += "OS          : $osInfo"
                    $header += "======================================================================="
                    $header += ""

                    # Prepend header safely: write header to temp file then append original content
                    $temp = [System.IO.Path]::GetTempFileName()
                    try {
                        [System.IO.File]::WriteAllLines($temp, $header, $enc)
                        [System.IO.File]::AppendAllLines($temp, (Get-Content -Path $Global:WinfigLogFilePath -Raw).Split([Environment]::NewLine), $enc)
                        Move-Item -Force -Path $temp -Destination $Global:WinfigLogFilePath
                    } finally {
                        if (Test-Path $temp) { Remove-Item $temp -ErrorAction SilentlyContinue }
                    }
                }
            }
        } catch {
            # ignore header-fix failures; continue logging
        }
    }

    if ($EndRun) {
        $endTime = Get-Date
        # $Global:WinfigLogStart is guaranteed to be set now
        $duration = $endTime - $Global:WinfigLogStart
        $footer = @()
        $footer += ""
        $footer += "--------------------------------------------------------------"
        $footer += "End Time    : $($endTime.ToString('yyyy-MM-dd HH:mm:ss'))"
        $footer += "Duration    : $($duration.ToString('dd\.hh\:mm\:ss') -replace '^00\.', '')"
        $footer += "Log Count   : $Global:LogCount"
        $footer += "Errors/Warn : $Global:ErrorCount / $Global:WarnCount"
        $footer += "===================== End of Winfig Log ======================"
        try {
            [System.IO.File]::AppendAllLines($Global:WinfigLogFilePath, $footer, $enc)
        } catch {
            $footer | Out-File -FilePath $Global:WinfigLogFilePath -Append -Encoding UTF8
        }
        return
    }

    $now = Get-Date
    $timestamp = $now.ToString("yyyy-MM-dd HH:mm:ss.fff")
    $logEntry = "[$timestamp] [$Level] $Message"

    $Global:LogCount++
    if ($Level -eq 'ERROR') { $Global:ErrorCount++ }
    if ($Level -eq 'WARN') { $Global:WarnCount++ }

    try {
        [System.IO.File]::AppendAllText($Global:WinfigLogFilePath, $logEntry + [Environment]::NewLine, $enc)
    } catch {
        Write-Host "Failed to write log to file: $($_.Exception.Message)" -ForegroundColor Yellow
        Write-Host $logEntry
    }
}

# ====================================================================== #
#  Main Functions
# ====================================================================== #

# ---------------------------------------------------------------------------- #
# Function to check if running as Administrator
function IsAdmin{
    $currentUser = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object System.Security.Principal.WindowsPrincipal($currentUser)
    if ($principal.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)) {
        Log-Message -Message "Script is running with Administrator privileges." -Level "SUCCESS"
    } else {
        Show-ErrorMessage "Script is NOT running with Administrator privileges."
        Log-Message -Message "Script is NOT running with Administrator privileges." -Level "ERROR"
        Log-Message "Forced exit." -EndRun
        $LogPathMessage = "Check the Log file for details: $($Global:WinfigLogFilePath)"
        Show-InfoMessage -Message $LogPathMessage
        exit 1
    }
}

# ---------------------------------------------------------------------------- #
# Function to check Working Internet Connection
function Test-InternetConnection {
    try {
        $request = [System.Net.WebRequest]::Create("http://www.google.com")
        $request.Timeout = 5000
        $response = $request.GetResponse()
        $response.Close()
        Log-Message -Message "Internet connection is available." -Level "SUCCESS"
        return $true
    } catch {
        Show-ErrorMessage "No internet connection available: $($_.Exception.Message)"
        Log-Message -Message "No internet connection available: $($_.Exception.Message)" -Level "ERROR"
        Log-Message "Forced exit." -EndRun
        $LogPathMessage = "Check the Log file for details: $($Global:WinfigLogFilePath)"
        Show-InfoMessage -Message $LogPathMessage
        exit 1

    }
}

# ---------------------------------------------------------------------------- #
# Function to Display Banner
function Winfig-Banner {
    Clear-Host
    Write-Host ""
    Write-Host ("  ██╗    ██╗██╗███╗   ██╗███████╗██╗ ██████╗  ".PadRight(70)) -ForegroundColor $Script:WinfigColors.Light
    Write-Host ("  ██║    ██║██║████╗  ██║██╔════╝██║██╔════╝  ".PadRight(70)) -ForegroundColor $Script:WinfigColors.Light
    Write-Host ("  ██║ █╗ ██║██║██╔██╗ ██║█████╗  ██║██║  ███╗ ".PadRight(70)) -ForegroundColor $Script:WinfigColors.Accent
    Write-Host ("  ██║███╗██║██║██║╚██╗██║██╔══╝  ██║██║   ██║ ".PadRight(70)) -ForegroundColor $Script:WinfigColors.Accent
    Write-Host ("  ╚███╔███╔╝██║██║ ╚████║██║     ██║╚██████╔╝ ".PadRight(70)) -ForegroundColor $Script:WinfigColors.Success
    Write-Host ("   ╚══╝╚══╝ ╚═╝╚═╝  ╚═══╝╚═╝     ╚═╝ ╚═════╝  ".PadRight(70)) -ForegroundColor $Script:WinfigColors.Success
    Write-Host ((" " * 70)) -ForegroundColor $Script:WinfigColors.Primary
    Write-Host ("" + $Script:WinfigMeta.CompanyName).PadLeft(40).PadRight(70) -ForegroundColor $Script:WinfigColors.Primary
    Write-Host ((" " * 70)) -ForegroundColor $Script:WinfigColors.Primary
    Write-Host ("  " + $Script:WinfigMeta.Description).PadRight(70) -ForegroundColor $Script:WinfigColors.Accent
    Write-Host ((" " * 70)) -ForegroundColor $Script:WinfigColors.Primary
    Write-Host (("  Version: " + $Script:WinfigMeta.Version + "    PowerShell: " + $Script:WinfigMeta.PowerShell).PadRight(70)) -ForegroundColor $Script:WinfigColors.Warning
    Write-Host (("  Author:  " + $Script:WinfigMeta.Author + "    Platform: " + $Script:WinfigMeta.Platform).PadRight(70)) -ForegroundColor $Script:WinfigColors.Warning
    Write-Host ""
}

# ---------------------------------------------------------------------------- #
# CTRL+C Signal Handler
trap {
    # Check if the error is due to a user interrupt (CTRL+C)
    if ($_.Exception.GetType().Name -eq "HostException" -and $_.Exception.Message -match "stopped by user") {

        # 1. Print the desired message
        Write-Host ""
        Write-Host ">>> [!] User interruption (CTRL+C) detected. Exiting gracefully..." -ForegroundColor $Script:WinfigColors.Accent

        # 2. Log the event before exit
        Log-Message -Message "Script interrupted by user (CTRL+C)." -Level "WARN"

        # 3. Write log footer before exiting
        if ($Global:WinfigLogFilePath) {
            Log-Message -Message "Script terminated by user (CTRL+C)." -EndRun
        }

        # 4. Terminate the script cleanly (exit code 1 is standard for non-zero exit)
        exit 1
    }
    # If it's a different kind of error, let the default behavior (or next trap) handle it
    continue
}

# ---------------------------------------------------------------------------- #
#  Check if git is installed
function Test-GitInstalled {
    try {
        git --version *> $null
        Log-Message -Message "Git is installed." -Level "SUCCESS"
        return $true
    } catch {
        Show-ErrorMessage "Git is not installed or not found in PATH."
        Log-Message -Message "Git is not installed or not found in PATH." -Level "ERROR"
        exit 1
    }
}

# ---------------------------------------------------------------------------- #
#  Zen Hardning (user.js)
function Zen-Hardening {
    $UserJsPath = [System.IO.Path]::Combine($Global:WinfigPaths.DotFiles, "winfig-browser", "Zen", "user.js")
    $UserJstarget = [System.IO.Path]::Combine($Global:WinfigPaths.zenProfile, "user.js")

    # Check Required File
    if (!(Test-Path $UserJsPath)) {
        Show-ErrorMessage "Zen user.js not found at $UserJsPath"
        Log-Message -Message "Zen user.js not found at $UserJsPath" -Level "ERROR"
        return
    }

    try {
        New-Item -ItemType SymbolicLink -Path $UserJstarget -Target $UserJsPath -Force | Out-Null
        Show-SuccessMessage "Zen hardening (user.js) applied successfully."
        Log-Message -Message "Zen hardening (user.js) applied successfully." -Level "SUCCESS"
    } catch {
        Show-ErrorMessage "Failed to apply Zen hardening: $($_.Exception.Message)"
        Log-Message -Message "Failed to apply Zen hardening: $($_.Exception.Message)" -Level "ERROR"
        return
    }
}

# ---------------------------------------------------------------------------- #
# Catppuchin Theme For Zen Browser
function Zen-CatppuchinTheme {
    $ChromeCss  = [System.IO.Path]::Combine($Global:WinfigPaths.DotFiles, "winfig-browser", "assets", "userCss", "userChrome.css")
    $ContentCss = [System.IO.Path]::Combine($Global:WinfigPaths.DotFiles, "winfig-browser", "assets", "userCss", "userContent.css")
    $Logo       = [System.IO.Path]::Combine($Global:WinfigPaths.DotFiles, "winfig-browser", "assets", "userCss", "zen-logo-mocha.svg")
    $ChromeJs   = [System.IO.Path]::Combine($Global:WinfigPaths.DotFiles, "winfig-browser", "assets", "userCss", "userChrome.js")

    $TargetChromeCss  = [System.IO.Path]::Combine($Global:WinfigPaths.zenChrome, "userChrome.css")
    $TargetContentCss = [System.IO.Path]::Combine($Global:WinfigPaths.zenChrome, "userContent.css")
    $TargetLogo       = [System.IO.Path]::Combine($Global:WinfigPaths.zenChrome, "zen-logo-mocha.svg")
    $TargetJs         = [System.IO.Path]::Combine($Global:WinfigPaths.zenChrome, "userChrome.js")

    $userChromeJsContent = Get-Content -Path $ChromeJs -Raw
    $sineModsPath = [System.IO.Path]::Combine($Global:WinfigPaths.zenChrome, "sine-mods") -replace '\\', '/'
    $userChromeJsContent = $userChromeJsContent -replace "<Sine-Path>", $sineModsPath
    Set-Content -Path $ChromeJs -Value $userChromeJsContent

    try {
        # Ensure the chrome directory exists
        if (-not (Test-Path $Global:WinfigPaths.zenChrome)) {
            New-Item -ItemType Directory -Path $Global:WinfigPaths.zenChrome -Force | Out-Null
        }
        # Remove existing files if they exist
        foreach ($target in @($TargetChromeCss, $TargetContentCss, $TargetLogo, $TargetJs)) {
            if (Test-Path $target) { Remove-Item $target -Force }
        }
        # Create symlinks for each file and log each step
        New-Item -ItemType SymbolicLink -Path $TargetChromeCss  -Target $ChromeCss  -Force | Out-Null
        Show-SuccessMessage "userChrome.css symlinked to Zen profile."
        Log-Message -Message "userChrome.css symlinked: $TargetChromeCss -> $ChromeCss" -Level "SUCCESS"

        New-Item -ItemType SymbolicLink -Path $TargetContentCss -Target $ContentCss -Force | Out-Null
        Show-SuccessMessage "userContent.css symlinked to Zen profile."
        Log-Message -Message "userContent.css symlinked: $TargetContentCss -> $ContentCss" -Level "SUCCESS"

        New-Item -ItemType SymbolicLink -Path $TargetLogo       -Target $Logo      -Force | Out-Null
        Show-SuccessMessage "zen-logo-mocha.svg symlinked to Zen profile."
        Log-Message -Message "zen-logo-mocha.svg symlinked: $TargetLogo -> $Logo" -Level "SUCCESS"

        New-Item -ItemType SymbolicLink -Path $TargetJs         -Target $ChromeJs   -Force | Out-Null
        Show-SuccessMessage "userChrome.js symlinked to Zen profile."
        Log-Message -Message "userChrome.js symlinked: $TargetJs -> $ChromeJs" -Level "SUCCESS"

        Write-Host ""
        Show-SuccessMessage "Catppuccin theme fully applied to Zen Browser!"
        Log-Message -Message "Catppuccin theme fully applied to Zen Browser." -Level "SUCCESS"
    } catch {
        Show-ErrorMessage "Failed to apply Zen Catppuccin theme: $($_.Exception.Message)"
        Log-Message -Message "Failed to apply Zen Catppuccin theme: $($_.Exception.Message)" -Level "ERROR"
    }
}

# --------------------------------------------------------------------------- #
# Install Zen Mods
function Install-ZenMods {
    $zenExe = "C:\Program Files\Zen Browser\zen.exe"
    $modCount = $Script:ZenMods.Count
    $current = 1

    foreach ($mod in $Script:ZenMods) {
        Write-Host
        Write-Host "======================================================================" -ForegroundColor $Script:WinfigColors.Accent
        Write-Host "Name       : $($mod.Name)" -ForegroundColor $Script:WinfigColors.Success
        Write-Host "Description: $($mod.Description)" -ForegroundColor $Script:WinfigColors.Info
        Write-Host "URL        : https://$($mod.url)" -ForegroundColor $Script:WinfigColors.Accent
        Write-Host "======================================================================" -ForegroundColor $Script:WinfigColors.Accent
        Show-InfoMessage "Opening Zen Mod page in Zen Browser..."
        Log-Message -Message "Opening Zen Mod page for: $($mod.Name)..." -Level "INFO"
        try {
            Start-Process $zenExe -ArgumentList "https://$($mod.url)"
            Show-InfoMessage "Please install the mod in the opened Zen window."
        } catch {
            Show-ErrorMessage "Failed to open Zen Mod page for: $($mod.Name): $($_.Exception.Message)"
            Log-Message -Message "Failed to open Zen Mod page for: $($mod.Name): $($_.Exception.Message)" -Level "ERROR"
        }
        Write-Host ""
        Write-Host "After installing the mod, return here and press ENTER to continue to the next mod." -ForegroundColor $Script:WinfigColors.Warning
        $null = Read-Host
        $current++
    }

    # Kill all Zen Browser processes after mods are installed
    Write-Host ""
    Show-InfoMessage "Closing all Zen Browser windows..."
    try {
        Get-Process -Name "zen" -ErrorAction SilentlyContinue | Stop-Process -Force
        Show-SuccessMessage "All Zen Browser processes have been closed."
        Log-Message -Message "All Zen Browser processes have been closed." -Level "SUCCESS"
    } catch {
        Show-WarningMessage "Could not close all Zen Browser processes (they may already be closed)."
        Log-Message -Message "Could not close all Zen Browser processes." -Level "WARN"
    }

    Write-Host ""
    Show-SuccessMessage "All Zen Mods have been processed."
    Log-Message -Message "All Zen Mods have been processed." -Level "SUCCESS"
}

# --------------------------------------------------------------------------- #
#  Install SINE
function Install-SINE {
    $Repourl = "https://github.com/CosmoCreeper/Sine"
    try {
        $latestRelease = Invoke-RestMethod -Uri "https://api.github.com/repos/CosmoCreeper/Sine/releases/latest"
        $asset = $latestRelease.assets | Where-Object { $_.name -eq "sine-win-x64.exe" }
        if ($null -eq $asset) {
            throw "Sine Windows x64 executable not found in the latest release."
        }
        $tempFilePath = [System.IO.Path]::Combine($Global:WinfigPaths.Temp, "sine-win-x64.exe")
        Invoke-WebRequest -Uri $asset.browser_download_url -OutFile $tempFilePath

        # Run the binary in a new cmd window and keep it open after execution
        Start-Process "cmd.exe" -ArgumentList "/c `"$tempFilePath & pause`"" -Wait

        Show-SuccessMessage "SINE installation completed."
        Write-Host ""
        Log-Message -Message "SINE installation completed." -Level "SUCCESS"
    } catch {
        Show-ErrorMessage "Failed to install SINE: $($_.Exception.Message)"
        Log-Message -Message "Failed to install SINE: $($_.Exception.Message)" -Level "ERROR"
    }
}

# --------------------------------------------------------------------------- #
# Download Sine Mods
function Install-SineMods {
    $target = [System.IO.Path]::Combine($Global:WinfigPaths.zenChrome, "sine-mods")
    $css    = [System.IO.Path]::Combine($target, "chrome.css")

    foreach ($mod in $Script:SineMods) {
        Write-Host
        Write-Host "======================================================================" -ForegroundColor $Script:WinfigColors.Accent
        Write-Host "Name       : $($mod.Name)" -ForegroundColor $Script:WinfigColors.Success
        Write-Host "Description: $($mod.Description)" -ForegroundColor $Script:WinfigColors.Info
        Write-Host "URL        : https://github.com/ $($mod.url)" -ForegroundColor $Script:WinfigColors.Accent
        Write-Host "======================================================================" -ForegroundColor $Script:WinfigColors.Accent

        Show-InfoMessage "Downloading Sine Mod..."
        Log-Message -Message "Downloading Sine Mod for: $($mod.Name)..." -Level "INFO"
        try {
            $modUrl = "https://github.com/$($mod.url).git"
            $modPath = [System.IO.Path]::Combine($target, $mod.Name)
            if (-not (Test-Path -Path $modPath)) {
                git clone $modUrl $modPath *> $null
            } else {
                Push-Location $modPath
                git pull *> $null
                Pop-Location
            }
            # after cloning add entries to chrome.css
            $modFiles = Get-ChildItem -Path $modPath -Filter "*.css" -Recurse
            foreach ($file in $modFiles) {
                # Get the absolute path and convert backslashes to forward slashes
                $absolutePath = $file.FullName -replace '\\', '/'
                $importStatement = "@import ('file:///$absolutePath');"
                Add-Content -Path $css -Value $importStatement
            }
        }
        catch {
            Show-ErrorMessage "Failed to download Sine Mod for: $($mod.Name): $($_.Exception.Message)"
            Log-Message -Message "Failed to download Sine Mod for: $($mod.Name): $($_.Exception.Message)" -Level "ERROR"
        }
    }
}

# --------------------------------------------------------------------------- #
# Add Sine Mods Entries to mods.json
function AppendZenMods {
    $jsonTarget    = [System.IO.Path]::Combine($Global:WinfigPaths.zenChrome, "sine-mods", "mods.json")
    $jsontemplate  = [System.IO.Path]::Combine($Global:WinfigPaths.DotFiles, "winfig-browser", "assets", "Sine", "mods.json")

    # Read target file (existing mods)
    if (Test-Path $jsonTarget) {
        try {
            $targetContent = Get-Content -Path $jsonTarget -Raw | ConvertFrom-Json
        } catch {
            Show-ErrorMessage "Failed to parse target file as JSON: $($_.Exception.Message)" -Level "ERROR"
            $targetContent = @{}
        }
    } else {
        $targetContent = @{}
    }

    # Read mods file (new mods to append)
    if (Test-Path $jsontemplate) {
        try {
            $modsContent = Get-Content -Path $jsontemplate -Raw | ConvertFrom-Json
        } catch {
            Show-ErrorMessage "Failed to parse mods file as JSON: $($_.Exception.Message)" -Level "ERROR"
            return
        }
    } else {
        return
    }

    $addedCount = 0
    foreach ($id in $modsContent.PSObject.Properties.Name) {
        Write-Host ""
        if ($targetContent.PSObject.Properties.Name -contains $id) {
            Show-InfoMessage "Mod '$id' already exists in target, skipping." -Level "INFO"
            continue
        }
        $targetContent | Add-Member -MemberType NoteProperty -Name $id -Value $modsContent.$id
        Show-InfoMessage "Appended mod '$id' to target." -Level "INFO"
        $addedCount++
    }

    $targetContent | ConvertTo-Json -Depth 6 | Set-Content $jsonTarget -Encoding UTF8
    Show-InfoMessage "$addedCount new mods appended to target.json." -Level "INFO"
}

# --------------------------------------------------------------------------- #
# Install Extensions
function Install-Extensions {
    $policies = [System.IO.Path]::Combine($Global:WinfigPaths.DotFiles, "winfig-browser", "Zen", "policies.json")
    $policiesDir = "C:\Program Files\Zen Browser\distribution"
    $targetPolicies = [System.IO.Path]::Combine($policiesDir, "policies.json")

    # Create folder if not exist
    if (!(Test-Path $policiesDir)) {
        New-Item -ItemType Directory -Path $policiesDir -Force | Out-Null
        Show-InfoMessage "Created policies directory: $policiesDir"
        Log-Message -Message "Created policies directory: $policiesDir" -Level "INFO"
    }

    # Symlink file to target
    try {
        New-Item -ItemType SymbolicLink -Path $targetPolicies -Target $policies -Force | Out-Null
        Show-SuccessMessage "Zen Browser policies.json symlinked successfully."
        Log-Message -Message "Zen Browser policies.json symlinked successfully." -Level "SUCCESS"
    } catch {
        Show-ErrorMessage "Failed to symlink Zen Browser policies.json: $($_.Exception.Message)"
        Log-Message -Message "Failed to symlink Zen Browser policies.json: $($_.Exception.Message)" -Level "ERROR"
        return
    }
}

# --------------------------------------------------------------------------- #
# Setup Stylus
function Stylus-Setup{
    $stylusImportPath = [System.IO.Path]::Combine($Global:WinfigPaths.DotFiles, "winfig-browser", "assets", "stylus", "import.json")
    $zenExe = "C:\Program Files\Zen Browser\zen.exe"

    # Check if import file exists
    if (!(Test-Path $stylusImportPath)) {
        Show-ErrorMessage "Stylus import file not found at $stylusImportPath"
        Log-Message -Message "Stylus import file not found at $stylusImportPath" -Level "ERROR"
        return
    }

    $stylusImportUrl =  "moz-extension://2e59fae4-fb48-4c38-9adc-c2ab21526772/manage.html"
    try {
        Set-Clipboard -Value $stylusImportPath
        Show-InfoMessage "Copied Stylus import file path to clipboard."
        Start-Process $zenExe -ArgumentList $stylusImportUrl
        Show-InfoMessage "Opened folder containing import file. Please select 'import.json' in the Stylus dialog."
        Show-WarningMessage "Manual action required: In the Stylus tab, click 'Import', then paste the path or select the file."
        Log-Message -Message "Opened Stylus import page, copied path to clipboard, and opened folder." -Level "INFO"
    } catch {
        $err = "Failed to open Stylus import page: $($_.Exception.Message)"
        Show-ErrorMessage $err
        Log-Message -Message $err -Level "ERROR"
    }
}

# --------------------------------------------------------------------------- #
# Setup Dark Reader
function DarkReader-Setup {
    $darkReaderSettingsPath = [System.IO.Path]::Combine($Global:WinfigPaths.DotFiles, "winfig-browser", "assets", "Darkreader", "import.json")
    $zenExe = "C:\Program Files\Zen Browser\zen.exe"

    # Check if settings file exists
    if (!(Test-Path $darkReaderSettingsPath)) {
        Show-ErrorMessage "Dark Reader settings file not found at $darkReaderSettingsPath"
        Log-Message -Message "Dark Reader settings file not found at $darkReaderSettingsPath" -Level "ERROR"
        return
    }

    $darkReaderOptionsUrl = "moz-extension://6bd37309-0f8b-4482-b8e1-7e38b33c7d3b/ui/options/index.html"
    try {
        Set-Clipboard -Value $darkReaderSettingsPath
        Start-Process $zenExe -ArgumentList $darkReaderOptionsUrl
        Show-InfoMessage "Opened Dark Reader options page in Zen Browser."
        Show-WarningMessage "Manual action: Please configure your Dark Reader settings as desired."
        Log-Message -Message "Opened Dark Reader options page for manual configuration." -Level "INFO"
    } catch {
        $err = "Failed to open Dark Reader options page: $($_.Exception.Message)"
        Show-ErrorMessage $err
        Log-Message -Message $err -Level "ERROR"
    }
}

# ====================================================================== #
#  Main Script Execution
# ====================================================================== #

Winfig-Banner
Write-SectionHeader -Title "Checking Requirements"
Write-Host ""

IsAdmin | Out-Null
Show-SuccessMessage "Administrator privileges confirmed."

# Test-InternetConnection | Out-Null
Show-SuccessMessage "Internet connection is available."

Test-GitInstalled | Out-Null
Show-SuccessMessage "Git installation check completed."

Write-Host ""
Prompt-UserContinue

Winfig-Banner
Write-SectionHeader -Title "Cloning Winfig Browser Repository"
Write-Host ""
$repoPath = Join-Path $Global:WinfigPaths.DotFiles "winfig-browser"
if (-not (Test-Path -Path $repoPath)) {
    try {
        Show-InfoMessage "Cloning Winfig Dotfiles repository..."
        Log-Message -Message "Cloning Winfig Dotfiles repository..." -Level "INFO"
        git clone https://github.com/Get-Winfig/winfig-browser.git $repoPath *> $null
    } catch {
        Show-ErrorMessage "Failed to clone Winfig Dotfiles repository: $($_.Exception.Message)"
        Log-Message -Message "Failed to clone Winfig Dotfiles repository: $($_.Exception.Message)" -Level "ERROR"
        exit 1
    }
    if (Test-Path -Path $repoPath) {
        Show-SuccessMessage "Cloned Winfig Dotfiles repository to $repoPath."
        Log-Message -Message "Cloned Winfig Dotfiles repository to $repoPath." -Level "SUCCESS"
    } else {
        Show-ErrorMessage "Winfig Dotfiles repository was not cloned. Please check your internet connection or repository URL."
        Log-Message -Message "Winfig Dotfiles repository was not cloned. Please check your internet connection or repository URL." -Level "ERROR"
        exit 1
    }
} else {
    try {
        Show-InfoMessage "Updating Winfig Dotfiles repository..."
        Log-Message -Message "Updating Winfig Dotfiles repository..." -Level "INFO"
        Push-Location $repoPath
        git pull *> $null
        Pop-Location
        Show-SuccessMessage "Updated Winfig Dotfiles repository at $repoPath."
        Log-Message -Message "Updated Winfig Dotfiles repository at $repoPath." -Level "SUCCESS"
    } catch {
        Show-ErrorMessage "Failed to update Winfig Dotfiles repository: $($_.Exception.Message)"
        Log-Message -Message "Failed to update Winfig Dotfiles repository: $($_.Exception.Message)" -Level "ERROR"
        exit 1
    }
}

Write-Host ""
Prompt-UserContinue

Winfig-Banner
Write-SectionHeader -Title "Theming, Hardning and Extensions"

Zen-Hardening
Zen-CatppuchinTheme
Install-Extensions

Write-Host ""
Prompt-UserContinue

Winfig-Banner
Write-SectionHeader -Title "Installing Zen Mods"

Install-ZenMods

Write-Host ""
Prompt-UserContinue

Winfig-Banner
Write-SectionHeader -Title "Installing Sine and Mods"

Install-SINE
Install-SineMods
AppendZenMods

Write-Host ""
Prompt-UserContinue

Winfig-Banner
Write-SectionHeader -Title "Setup Extensions"

Stylus-Setup
Start-Sleep -Seconds 30
DarkReader-Setup

Write-Host ""
Write-SectionHeader -Title "Thank You For Using Winfig Browser" -Description "https://github.com/Get-Winfig/"
Show-WarningMessage -Message "Restart Windows to apply changes"
Write-Host ""
Log-Message -Message "Logging Completed." -EndRun
