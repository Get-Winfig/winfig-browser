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

# ====================================================================== #
# Start Time, Resets, Counters
# ====================================================================== #
$Global:WinfigLogStart = Get-Date
$Global:WinfigLogFilePath = $null
Remove-Variable -Name WinfigLogFilePath -Scope Global -ErrorAction SilentlyContinue
Remove-Variable -Name LogCount -Scope Global -ErrorAction SilentlyContinue
Remove-Variable -Name ErrorCount -Scope Global -ErrorAction SilentlyContinue
Remove-Variable -Name WarnCount -Scope Global -ErrorAction SilentlyContinue

# ===================================================================== #
# Extensions List
# ===================================================================== #
$Script:Extensions = @(
    @{ ID = "enicfllfdibbjhnpembomakaamcdcakl"; Name = "Catppuccin for Web File Explorer Icons"; Description = "Soothing pastel icons for web file explorers" }
    @{ ID = "mnbndgmknlpdjdnjfmfcdjoegcckoikn"; Name = "Wappalyzer - Technology profiler"; Description = "IdenIdentify web technologies" }
    @{ ID = "akjbkjciknacicbnkfjbnlaeednpadcf"; Name = "GitHub Web IDE"; Description = "Web-based integrated development environment for GitHub" }
    @{ ID = "eibibhailjcnbpjmemmcaakcookdleon"; Name = "Enhanced GitHub"; Description = "GitHub enhancements for better productivity" }
    @{ ID = "odfafepnkmbhccpbejgmiehpchacaeak"; Name = "uBlock Origin"; Description = "An efficient blocker for ads and trackers" }
    @{ ID = "neaplmfkghagebokkhpjpoebhdledlfi"; Name = "Cookie-Editor"; Description = "Manage browser cookies easily" }
    @{ ID = "cnjkedgepfdpdbnepgmajmmjdjkjnifa"; Name = "User-Agent Switcher"; Description = "Switch user-agent strings quickly" }
    @{ ID = "ilbdhapjffldgngebmnkdodohjapjccm"; Name = "Web Developer"; Description = "Adds a toolbar button with various web developer tools."}
    @{ ID = "ifoakfbpdcdoeenechcleahebpibofpc"; Name = "Dark Reader"; Description = "Trim dark mode for every website" }
    @{ ID = "mdkdmaickkfdekbjdoojfalpbkgaddei"; Name = "Clean URLs"; Description = "Remove tracking elements from URLs to help protect your privacy when browsing the web." }
    @{ ID = "hmclfiddnlhfnemdelgodbcmhpobomha"; Name = "Smart HTTPS"; Description = "Try to use HTTPS on every website" }
)

$Script:ChromeExtensions = @(
    @{ ID = "jieoogmcigenidbkgnkaakagdnlnieap"; Name = "SimRepo"; Description = "Shows similar repositories on GitHub" }
    @{ ID = "bnjjngeaknajbdcgpfkgnonkmififhfo"; Name = "Fake Filler"; Description = "A form filler that fills all inputs on a page with fake/dummy data."}
    @{ ID = "gcknhkkoolaabfmlnjonogaaifnjlfnp"; Name = "FoxyProxy"; Description = "Easy to use advanced Proxy Management tool for everyone"}
    @{ ID = "lefcpjbffalgdcdgidjdnmabfenecjdf"; Name = "GitHub Code Folding"; Description = "Enable code folding when viewing files in GitHub."}
    @{ ID = "eifflpmocdbdmepbjaopkkhbfmdgijcc"; Name = "JSON Viewer Pro"; Description = "JSON Viewer Pro makes JSON easy to read!"}
    @{ ID = "gabfmnliflodkdafenbcpjdlppllnemd"; Name = "Save image as Type"; Description = "Save Images as PNG, JPG, BMP, GIF, WEBP"}
    @{ ID = "emffkefkbkpkgpdeeooapgaicgmcbolj"; Name = "Wikiwand "; Description = "The modern interface for Wikipedia"}
    @{ ID = "efbjojhplkelaegfbieplglfidafgoka"; Name = "VT4Browsers "; Description = "VirusTotal and Google Threat Intelligence Browser Extension."}
    @{ ID = "ffabmkklhbepgcgfonabamgnfafbdlkn"; Name = "GitZip for github"; Description = "It can make the sub-directories and files of github repository as zip and download it"}
    @{ ID = "clngdbkpkpeebahjckkjfobafhncgmne"; Name = "Stylus"; Description = "Custom themes for any website" }
)

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

# --------------------------------------------------------------------------- #
# Helper function to set and log Edge policy
function Set-EdgePolicy {
    param (
        [string]$Name,
        [Parameter(Mandatory=$true)][object]$Value,
        [string]$Type = "DWord",
        [string]$Description = ""
    )
    try {
        Set-ItemProperty -Path $EdgePolicyPath -Name $Name -Value $Value -Type $Type
        $msg = "Set policy: $Name = $Value"
        if ($Description) { $msg += " ($Description)" }
        Show-SuccessMessage $msg
        Log-Message -Message $msg -Level "SUCCESS"
    } catch {
        $err = "Failed to set policy: $Name ($($_.Exception.Message))"
        Show-ErrorMessage $err
        Log-Message -Message $err -Level "ERROR"
    }
}

# --------------------------------------------------------------------------- #
# Helper function to set and log Edge sync type policy
function Set-EdgeSyncType {
    param (
        [int]$Index,
        [string]$Value
    )
    try {
        Set-ItemProperty -Path $SyncTypesPath -Name "$Index" -Value $Value -Type String
        $msg = "Disabled sync for: $Value"
        Show-SuccessMessage $msg
        Log-Message -Message $msg -Level "SUCCESS"
    } catch {
        $err = "Failed to disable sync for: $Value ($($_.Exception.Message))"
        Show-ErrorMessage $err
        Log-Message -Message $err -Level "ERROR"
    }
}

# --------------------------------------------------------------------------- #
# Check and Install Extensions from Edge Add-ons Store
function Install-EdgeExtension {
    $ForceInstallPath = "HKLM:\SOFTWARE\Policies\Microsoft\Edge\ExtensionInstallForcelist"
    $BlocklistPath    = "HKLM:\SOFTWARE\Policies\Microsoft\Edge\ExtensionInstallBlocklist"
    $UpdateUrl        = "https://edge.microsoft.com/extensionwebstorebase/v1/crx"

    # Ensure registry keys exist
    if (-not (Test-Path $ForceInstallPath)) { New-Item -Path $ForceInstallPath -Force | Out-Null }
    if (-not (Test-Path $BlocklistPath))   { New-Item -Path $BlocklistPath   -Force | Out-Null }

    $index = 1
    foreach ($ext in $Script:Extensions) {
        $extId = $ext.ID
        $extName = $ext.Name
        $extDesc = $ext.Description

        # Add to Force Install List (use sequential numbers as value names)
        try {
            Set-ItemProperty -Path $ForceInstallPath -Name "$index" -Value "$extId;$UpdateUrl" -Type String
            $msg = "Added extension to Force Install list: $extName ($extId) as $index"
            Show-SuccessMessage $msg
            Log-Message -Message $msg -Level "SUCCESS"
        } catch {
            $err = "Failed to add extension to Force Install list: $extName ($($_.Exception.Message))"
            Show-ErrorMessage $err
            Log-Message -Message $err -Level "ERROR"
            continue
        }

        # Remove from Blocklist if present (optional, also use numbers if needed)
        try {
            Set-ItemProperty -Path $BlocklistPath -Name "$index" -Value 0 -Type DWord
            $msg = "Removed extension from Blocklist: $extName ($extId) as $index"
            Show-SuccessMessage $msg
            Log-Message -Message $msg -Level "SUCCESS"
        } catch {
            $err = "Failed to remove extension from Blocklist: $extName ($($_.Exception.Message))"
            Show-ErrorMessage $err
            Log-Message -Message $err -Level "ERROR"
        }

        $index++
    }
}

# --------------------------------------------------------------------------- #
# Open Chrome Web Store Extensions for Manual Installation
function Install-ChromeExtensions {
    if ($Script:ChromeExtensions.Count -eq 0) {
        Show-InfoMessage "No Chrome Web Store extensions specified for manual installation."
        Log-Message -Message "No Chrome Web Store extensions specified for manual installation." -Level "INFO"
        return
    }

    foreach ($ext in $Script:ChromeExtensions) {
        $extId = $ext.ID
        $extName = $ext.Name
        $url = "https://chrome.google.com/webstore/detail/$extId"
        try {
            Start-Process "msedge.exe" $url
            $msg = "Opened Chrome Web Store page for: $extName ($extId)"
            Show-InfoMessage $msg
            Log-Message -Message $msg -Level "INFO"
        } catch {
            $err = "Failed to open Chrome Web Store page for: $extName ($($_.Exception.Message))"
            Show-ErrorMessage $err
            Log-Message -Message $err -Level "ERROR"
        }
    }
    Show-WarningMessage "Please manually click 'Add to Edge' for each opened extension page."
    Log-Message -Message "Prompted user for manual Chrome extension installation." -Level "WARN"
}

# --------------------------------------------------------------------------- #
# Setup Stylus
function Stylus-Setup{
    $stylusImportPath = [System.IO.Path]::Combine($Global:WinfigPaths.DotFiles, "winfig-browser", "assets", "stylus", "import.json")

    # Check if import file exists
    if (!(Test-Path $stylusImportPath)) {
        Show-ErrorMessage "Stylus import file not found at $stylusImportPath"
        Log-Message -Message "Stylus import file not found at $stylusImportPath" -Level "ERROR"
        return
    }

    # Attempt to check if Stylus is installed (basic check for extension folder in Edge profile)
    $edgeProfilePath = Join-Path $env:LOCALAPPDATA "Microsoft\Edge\User Data\Default\Extensions"
    $stylusExtId = "clngdbkpkpeebahjckkjfobafhncgmne"
    $stylusExtPath = Join-Path $edgeProfilePath $stylusExtId
    if (!(Test-Path $stylusExtPath)) {
        Show-WarningMessage "Stylus extension does not appear to be installed in Edge. Please install it from the Edge Add-ons or Chrome Web Store first."
        Log-Message -Message "Stylus extension not found at $stylusExtPath" -Level "WARN"
        return
    }

    $stylusImportUrl =  "chrome-extension://clngdbkpkpeebahjckkjfobafhncgmne/manage.html"
    try {
        Set-Clipboard -Value $stylusImportPath
        Show-InfoMessage "Copied Stylus import file path to clipboard."
        Start-Process "msedge.exe" $stylusImportUrl
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

    # Check if settings file exists
    if (!(Test-Path $darkReaderSettingsPath)) {
        Show-ErrorMessage "Dark Reader settings file not found at $darkReaderSettingsPath"
        Log-Message -Message "Dark Reader settings file not found at $darkReaderSettingsPath" -Level "ERROR"
        return
    }

    # Attempt to check if Dark Reader is installed (basic check for extension folder in Edge profile)
    $edgeProfilePath = Join-Path $env:LOCALAPPDATA "Microsoft\Edge\User Data\Default\Extensions"
    $darkReaderExtId = "ifoakfbpdcdoeenechcleahebpibofpc"
    $darkReaderExtPath = Join-Path $edgeProfilePath $darkReaderExtId
    if (!(Test-Path $darkReaderExtPath)) {
        Show-WarningMessage "Dark Reader extension does not appear to be installed in Edge. Please install it from the Edge Add-ons or Chrome Web Store first."
        Log-Message -Message "Dark Reader extension not found at $darkReaderExtPath" -Level "WARN"
        return
    }

    $darkReaderOptionsUrl = "chrome-extension://ifoakfbpdcdoeenechcleahebpibofpc/ui/options/index.html"
    try {
        Set-Clipboard -Value $darkReaderSettingsPath
        Start-Process "msedge.exe" $darkReaderOptionsUrl
        Show-InfoMessage "Opened Dark Reader options page in Edge."
        Show-WarningMessage "Manual action: Please configure your Dark Reader settings as desired."
        Log-Message -Message "Opened Dark Reader options page for manual configuration." -Level "INFO"
    } catch {
        $err = "Failed to open Dark Reader options page: $($_.Exception.Message)"
        Show-ErrorMessage $err
        Log-Message -Message $err -Level "ERROR"
    }
}

# --------------------------------------------------------------------------- #
# Wait for Extensions to be Installed
function Wait-ForExtensions {
    param(
        [string[]]$ExtensionIds,
        [int]$TimeoutSeconds = 60,
        [int]$PollIntervalSeconds = 3
    )
    $edgeProfilePath = Join-Path $env:LOCALAPPDATA "Microsoft\Edge\User Data\Default\Extensions"
    $start = Get-Date
    $missing = $ExtensionIds

    while ($true) {
        $missing = @()
        foreach ($extId in $ExtensionIds) {
            $extPath = Join-Path $edgeProfilePath $extId
            if (!(Test-Path $extPath)) {
                $missing += $extId
            }
        }
        if ($missing.Count -eq 0) {
            Show-SuccessMessage "All required extensions are installed."
            return
        }
        $elapsed = (Get-Date) - $start
        if ($elapsed.TotalSeconds -ge $TimeoutSeconds) {
            Show-WarningMessage "Timeout waiting for extensions: $($missing -join ', ')"
            break
        }
        Start-Sleep -Seconds $PollIntervalSeconds
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

Write-Host ""
Prompt-UserContinue

Winfig-Banner
Write-SectionHeader -Title "Clone Winfig Browser Repository"
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
Write-SectionHeader -Title "Setting up Edge Browser Policies"

# Define Edge policy registry path
$EdgePolicyPath = "HKLM:\SOFTWARE\Policies\Microsoft\Edge"

# ===================== First-Run, Annoyances, Prompts =====================
Set-EdgePolicy -Name "HideFirstRunExperience" -Value 1 -Type DWord -Description "Hide first run experience"
Set-EdgePolicy -Name "ShowRecommendationsEnabled" -Value 0 -Type DWord -Description "Disable recommendations on new tab and elsewhere"
Set-EdgePolicy -Name "SpotlightExperiencesAndRecommendationsEnabled" -Value 0 -Type DWord -Description "Disable Spotlight and recommendations"
Set-EdgePolicy -Name "EdgeShoppingAssistantEnabled" -Value 0 -Type DWord -Description "Disable Edge Shopping Assistant"
Set-EdgePolicy -Name "EdgeAssetDeliveryServiceEnabled" -Value 0 -Type DWord -Description "Disable Edge Asset Delivery Service"

# ===================== Startup & UI Behavior =====================
Set-EdgePolicy -Name "ShowHomeButton" -Value 1 -Type DWord -Description "Show Home button in toolbar"

# ===================== Search Engine Defaults =====================
Set-EdgePolicy -Name "DefaultSearchProviderEnabled" -Value 1 -Type DWord -Description "Enable Default Search Provider"
Set-EdgePolicy -Name "DefaultSearchProviderName" -Value "Google" -Type String -Description "Set search provider name"
Set-EdgePolicy -Name "DefaultSearchProviderSearchURL" -Value "https://www.google.com/search?q={searchTerms}" -Type String -Description "Set search URL"

# ===================== Passwords, Autofill, Payments =====================
Set-EdgePolicy -Name "PasswordManagerEnabled" -Value 0 -Type DWord -Description "Disable password manager"
Set-EdgePolicy -Name "AutofillAddressEnabled" -Value 0 -Type DWord -Description "Disable address autofill"
Set-EdgePolicy -Name "AutofillCreditCardEnabled" -Value 0 -Type DWord -Description "Disable credit card autofill"

# ===================== Sidebar, Copilot, Bing Stuff =====================
Set-EdgePolicy -Name "HubsSidebarEnabled" -Value 0 -Type DWord -Description "Disable Hubs Sidebar"
Set-EdgePolicy -Name "BingAdsSuppression" -Value 1 -Type DWord -Description "Suppress Bing Ads"

# ===================== Downloads & Files =====================
Set-EdgePolicy -Name "PromptForDownloadLocation" -Value 1 -Type DWord -Description "Prompt for download location"
Set-EdgePolicy -Name "DownloadRestrictions" -Value 0 -Type DWord -Description "No download restrictions"

# ===================== Sync (Optional) =====================
Set-EdgePolicy -Name "SyncDisabled" -Value 1 -Type DWord -Description "Disable all sync"

# ===================== Other Privacy & Telemetry =====================
Set-EdgePolicy -Name "ConfigureDoNotTrack" -Value 1 -Type DWord -Description "Enable Do Not Track"
Set-EdgePolicy -Name "PersonalizationReportingEnabled" -Value 0 -Type DWord -Description "Disable personalization reporting"
Set-EdgePolicy -Name "UserFeedbackAllowed" -Value 0 -Type DWord -Description "Disable user feedback"
Set-EdgePolicy -Name "DiagnosticData" -Value 0 -Type DWord -Description "Disable diagnostic data"
Set-EdgePolicy -Name "EdgeCollectionsEnabled" -Value 0 -Type DWord -Description "Disable Edge Collections"
Set-EdgePolicy -Name "WalletDonationEnabled" -Value 0 -Type DWord -Description "Disable Wallet Donation"

# ===================== Additional Search Provider Policies =====================
Set-EdgePolicy -Name "DefaultSearchProviderKeyword" -Value "google.com" -Type String -Description "Set search provider keyword"
Set-EdgePolicy -Name "DefaultSearchProviderSuggestURL" -Value "https://www.google.com/complete/search?output=chrome&q={searchTerms}" -Type String -Description "Set suggest URL"
Set-EdgePolicy -Name "DefaultSearchProviderImageURL" -Value "https://www.google.com/searchbyimage?image_url={google:imageURL}" -Type String -Description "Set image search URL"
Set-EdgePolicy -Name "DefaultSearchProviderImageURLPostParams" -Value "" -Type String -Description "Set image search POST params"

# ===================== Promotional Tabs, Payment Method Query, Web Widget, Tracking Prevention =====================
Set-EdgePolicy -Name "PromotionalTabsEnabled" -Value 0 -Type DWord -Description "Disable promotional tabs"
Set-EdgePolicy -Name "PaymentMethodQueryEnabled" -Value 0 -Type DWord -Description "Disable payment method query"
Set-EdgePolicy -Name "WebWidgetAllowed" -Value 0 -Type DWord -Description "Disable web widget"
Set-EdgePolicy -Name "TrackingPrevention" -Value 3 -Type DWord -Description "Set tracking prevention to strict"

# --- Disable Sync for Specific Data Types ---
$SyncTypesPath = "HKLM:\SOFTWARE\Policies\Microsoft\Edge\SyncTypesListDisabled"
New-Item -Path $SyncTypesPath -Force | Out-Null
$syncTypes = @(
    "favorites", "apps", "edgeFeatureUsage", "settings", "passwords",
    "addressesAndMore", "extensions", "history", "openTabs", "edgeWallet", "collections"
)
for ($i = 0; $i -lt $syncTypes.Count; $i++) {
    Set-EdgeSyncType -Index ($i + 1) -Value $syncTypes[$i]
}

# --- Edge Update Policies ---
$EdgeUpdatePath = "HKLM:\SOFTWARE\Policies\Microsoft\EdgeUpdate"
New-Item -Path $EdgeUpdatePath -Force | Out-Null
try {
    Set-ItemProperty -Path $EdgeUpdatePath -Name "CreateDesktopShortcutDefault" -Value 0 -Type DWord
    Show-SuccessMessage "Set Edge update policy: Do not create desktop shortcut"
    Log-Message -Message "Set Edge update policy: Do not create desktop shortcut" -Level "SUCCESS"
} catch {
    Show-ErrorMessage "Failed to set Edge update policy: $($_.Exception.Message)"
    Log-Message -Message "Failed to set Edge update policy: $($_.Exception.Message)" -Level "ERROR"
}

# --- End of Policy Setup ---
Show-InfoMessage "Edge policies have been configured. Please restart Windows to apply changes."
Log-Message -Message "Edge policies have been configured. Please restart Windows to apply changes." -Level "INFO"

Write-Host ""
Prompt-UserContinue

Winfig-Banner
Write-SectionHeader -Title "Setting up Edge Browser Extensions"

Install-EdgeExtension
Install-ChromeExtensions

# Wait for required extensions before setup
Wait-ForExtensions -ExtensionIds @(
    "clngdbkpkpeebahjckkjfobafhncgmne", # Stylus
    "ifoakfbpdcdoeenechcleahebpibofpc" # Dark Reader
) -TimeoutSeconds 90

Write-Host ""
Prompt-UserContinue

Winfig-Banner
Write-SectionHeader -Title "Setting up Extensions"

Stylus-Setup
Start-Sleep -Seconds 30
DarkReader-Setup

Write-Host ""
Write-SectionHeader -Title "Thank You For Using Winfig Browser" -Description "https://github.com/Get-Winfig/"
Show-WarningMessage -Message "Restart Windows to apply changes"
Write-Host ""
Log-Message -Message "Logging Completed." -EndRun
