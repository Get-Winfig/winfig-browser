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
    @{ ID = "hlkenndednhfkekhgcdicdfddnkalmdm"; Name = "Cookie Editor"; Description = "Advanced cookie manager for viewing, editing, creating, deleting, and protecting cookies" }
    @{ ID = "eimadpbcbfnmbkopoojfekhnkhdbieeh"; Name = "Dark Reader"; Description = "Dark mode for every website with adjustable brightness, contrast, and sepia filters" }
    @{ ID = "bnjjngeaknajbdcgpfkgnonkmififhfo"; Name = "Fake Filler"; Description = "Auto-fills form fields with realistic fake data for testing and development" }
    @{ ID = "gcknhkkoolaabfmlnjonogaaifnjlfnp"; Name = "FoxyProxy"; Description = "Advanced proxy management tool with pattern-matching and automatic switching" }
    @{ ID = "lefcpjbffalgdcdgidjdnmabfenecjdf"; Name = "GitHub Code Folding"; Description = "Adds code folding functionality to GitHub's file viewer for better code navigation" }
    @{ ID = "adjiklnjodbiaioggfpbpkhbfcnhgkfe"; Name = "GitHub Web IDE"; Description = "Adds feature to open repo in different IDEs" }
    @{ ID = "diilnnhpcdjhhkjcbdljaonhmhapadap"; Name = "GitHub Writer"; Description = "Enhanced markdown editor for GitHub with preview and formatting tools" }
    @{ ID = "ffabmkklhbepgcgfonabamgnfafbdlkn"; Name = "GitZip for github"; Description = "Download individual files or folders from GitHub repositories" }
    @{ ID = "cmbndhnoonmghfofefkcccljbkdpamhi"; Name = "Hack Tools"; Description = "Collection of penetration testing tools for web application security assessment" }
    @{ ID = "fabjnpecogealbfoebkcjfbmdhnnfhbj"; Name = "HTTP Headers"; Description = "View and analyze HTTP request and response headers in real-time" }
    @{ ID = "eifflpmocdbdmepbjaopkkhbfmdgijcc"; Name = "JSON Viewer Pro"; Description = "Formats, validates, and provides syntax highlighting for JSON data" }
    @{ ID = "ciilcijdmepbaiocfaacfcmcnkdhjnag"; Name = "Retire Js"; Description = "Scans websites for JavaScript libraries with known vulnerabilities" }
    @{ ID = "gabfmnliflodkdafenbcpjdlppllnemd"; Name = "Save image as Type"; Description = "Allows saving images in specific formats (PNG, JPG, WebP) regardless of source format" }
    @{ ID = "lnjaiaapbakfhlbjenjkhffcdpoompki"; Name = "Catppuccin for Web File Explorer Icons"; Description = "Applies Catppuccin color theme to file explorer icons on web pages" }
    @{ ID = "chphlpgkkbolifaimnlloiipkdnihall"; Name = "One Tab"; Description = "Consolidates browser tabs into a single tab to reduce memory usage and clutter" }
    @{ ID = "cidlcjdalomndpeagkjpnefhljffbnlo"; Name = "Toggle JavaScript"; Description = "Quickly enable/disable JavaScript on any website with one click" }
    @{ ID = "bhchdcejhohfmigjafbampogmaanbfkg"; Name = "User-Agent Switcher and Manager"; Description = "Switch between different user agents (browser identities) for testing" }
    @{ ID = "efbjojhplkelaegfbieplglfidafgoka"; Name = "VT4Browsers"; Description = "VirusTotal integration for checking URLs and files directly from the browser" }
    @{ ID = "gppongmhjkpfnbhagpmjfkannfbllamg"; Name = "Wappalyzer"; Description = "Identifies technologies used on websites (CMS, frameworks, analytics, etc.)" }
    @{ ID = "pbkloffickinnlnmefmjmjbacohecpbd"; Name = "Web Cache Viewer"; Description = "Access and view cached versions of web pages from various sources" }
    @{ ID = "fgcokeipnkbcjndbhcmdcjpigplhfkbk"; Name = "Webpage Sherlock"; Description = "Page insights made easy" }
    @{ ID = "emffkefkbkpkgpdeeooapgaicgmcbolj"; Name = "Wikiwand"; Description = "Modern Wikipedia interface with improved readability and navigation" }
    @{ ID = "ckddhlieecghofpfojemicbieacljgji"; Name = "WordPress Theme and Plugin Detector"; Description = "Identifies WordPress themes and plugins used on websites" }
    @{ ID = "ehafadccdcdedbhcbddihehiodgcddpl"; Name = "Yet Another REST Client"; Description = "Tool for testing and debugging REST APIs directly from the browser" }
    @{ ID = "jieoogmcigenidbkgnkaakagdnlnieap"; Name = "SimRepo"; Description = "Simplified GitHub repository viewer with enhanced file browsing" }
    @{ ID = "fpnmgdkabkmnadcjpehmlllkndpkmiak"; Name = "Wayback Machine"; Description = "Access archived versions of web pages from the Internet Archive" }
    @{ ID = "clngdbkpkpeebahjckkjfobafhncgmne"; Name = "Stylus"; Description = "Custom CSS manager for modifying website appearance with user styles" }
    @{ ID = "anlikcnbgdeidpacdbdljnabclhahhmd"; Name = "Enhanced GitHub"; Description = "Adds various productivity features to GitHub's interface" }
    @{ ID = "bfbameneiokkgbdmiekhjnmfkcnldhhm"; Name = "Web Developer"; Description = "Comprehensive toolbox for web development and debugging" }
    @{ ID = "ccjfggejcoobknjolglgmfhoeneafhhm"; Name = "ChatGPT to PDF"; Description = "Export ChatGPT conversations to PDF format with formatting preserved" }
    @{ ID = "lpfemeioodjbpieminkklglpmhlngfcn"; Name = "WebChatGPT"; Description = "Enhances ChatGPT with web search capabilities for more current responses" }
    @{ ID = "amhmeenmapldpjdedekalnfifgnpfnkc"; Name = "Superpower ChatGPT"; Description = "Adds advanced features to ChatGPT including prompt management and export" }
    @{ ID = "bcfcapocaillaifbiefjabaikkchghko"; Name = "Prompt Stash"; Description = "Save, organize, and reuse AI prompts across different platforms" }
    @{ ID = "ginpbkfigcoaokgflihfhhmglmbchinc"; Name = "HackBar"; Description = "Security testing toolbar with common penetration testing tools and payloads" }
    @{ ID = "hgmhmanijnjhaffoampdlllchpolkdnj"; Name = "Hunter.io"; Description = "Find email addresses associated with a website" }
    @{ ID = "jjalcfnidlmpjhdfepjhjbhnhkbgleap"; Name = "Shodan"; Description = "Shodan.io integration for IoT and device search" }
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
# Helper function to set and log Brave policy
function Set-BravePolicy {
    param (
        [string]$Name,
        [Parameter(Mandatory=$true)][object]$Value,
        [string]$Type = "DWord",
        [string]$Description = ""
    )
    try {
        Set-ItemProperty -Path $BravePolicyPath -Name $Name -Value $Value -Type $Type
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
# Check and Install Extensions from Chrome Web Store for Brave
function Install-BraveExtension {
    Write-Host "[DEBUG] Install-BraveExtension called"
    $ForceInstallPath = "HKLM:\SOFTWARE\Policies\BraveSoftware\Brave\ExtensionInstallForcelist"
    $BlocklistPath    = "HKLM:\SOFTWARE\Policies\BraveSoftware\Brave\ExtensionInstallBlocklist"
    $SourcesPath      = "HKLM:\SOFTWARE\Policies\BraveSoftware\Brave\ExtensionInstallSources"
    $UpdateUrl        = "https://clients2.google.com/service/update2/crx"

    # Ensure registry keys exist
    if (-not (Test-Path $ForceInstallPath)) { New-Item -Path $ForceInstallPath -Force | Out-Null }
    if (-not (Test-Path $BlocklistPath))   { New-Item -Path $BlocklistPath   -Force | Out-Null }
    if (-not (Test-Path $SourcesPath))     { New-Item -Path $SourcesPath     -Force | Out-Null }

    # Add Chrome Web Store as allowed source (optional but good practice)
    try {
        Set-ItemProperty -Path $SourcesPath -Name "1" -Value "https://clients2.google.com/service/update2/crx" -Type String
        Show-SuccessMessage "Added Chrome Web Store as allowed extension source"
    } catch {
        Show-ErrorMessage "Failed to add Chrome Web Store as allowed source: $($_.Exception.Message)"
    }

    $index = 1
    foreach ($ext in $Script:Extensions) {
        $extId = $ext.ID
        $extName = $ext.Name
        $extDesc = $ext.Description

        # Add to Force Install List (use sequential numbers as value names)
        try {
            Set-ItemProperty -Path $ForceInstallPath -Name "$index" -Value "$extId;$UpdateUrl" -Type String
            $msg = "Added extension to Brave Force Install list: $extName ($extId) as entry $index"
            Show-SuccessMessage $msg
            Log-Message -Message $msg -Level "SUCCESS"
        } catch {
            $err = "Failed to add extension to Brave Force Install list: $extName ($($_.Exception.Message))"
            Show-ErrorMessage $err
            Log-Message -Message $err -Level "ERROR"
            continue
        }

        # Remove from Blocklist if present (Brave uses String type for blocklist)
        try {
            Remove-ItemProperty -Path $BlocklistPath -Name "$extId" -ErrorAction SilentlyContinue
            $msg = "Ensured extension not in Brave Blocklist: $extName ($extId)"
            Show-SuccessMessage $msg
            Log-Message -Message $msg -Level "SUCCESS"
        } catch {
            # No error handling needed - it's okay if property doesn't exist
        }

        $index++
    }
}


# --------------------------------------------------------------------------- #
# Setup Stylus
function Stylus-Setup{
    $stylusImportPath = [System.IO.Path]::Combine($Global:WinfigPaths.DotFiles, "winfig-browser", "assets", "stylus", "import.json")
    $braveExe = [System.IO.Path]::Combine($Global:WinfigPaths.AppDataLocal, 'BraveSoftware', 'Brave-Browser', 'Application', 'brave.exe')

    # Check if import file exists
    if (!(Test-Path $stylusImportPath)) {
        Show-ErrorMessage "Stylus import file not found at $stylusImportPath"
        Log-Message -Message "Stylus import file not found at $stylusImportPath" -Level "ERROR"
        return
    }

    $stylusImportUrl =  "chrome-extension://clngdbkpkpeebahjckkjfobafhncgmne/manage.html"
    try {
        Set-Clipboard -Value $stylusImportPath
        Show-InfoMessage "Copied Stylus import file path to clipboard."
        Start-Process $braveExe -ArgumentList $stylusImportUrl
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
    $braveExe = [System.IO.Path]::Combine($Global:WinfigPaths.AppDataLocal, 'BraveSoftware', 'Brave-Browser', 'Application', 'brave.exe')

    # Check if settings file exists
    if (!(Test-Path $darkReaderSettingsPath)) {
        Show-ErrorMessage "Dark Reader settings file not found at $darkReaderSettingsPath"
        Log-Message -Message "Dark Reader settings file not found at $darkReaderSettingsPath" -Level "ERROR"
        return
    }

    $darkReaderOptionsUrl = "chrome-extension://eimadpbcbfnmbkopoojfekhnkhdbieeh/ui/options/index.html"
    try {
        Set-Clipboard -Value $darkReaderSettingsPath
        Start-Process $braveExe -ArgumentList $darkReaderOptionsUrl
        Show-InfoMessage "Opened Dark Reader options page in Brave Browser."
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
Write-SectionHeader -Title "Setting up Brave Browser Policies"

# Define Brave policy registry path
$BravePolicyPath = "HKLM:\SOFTWARE\Policies\BraveSoftware\Brave"

# Create the Brave policy registry key if it doesn't exist
if (-not (Test-Path -Path $BravePolicyPath)) {
    try {
        New-Item -Path $BravePolicyPath -Force | Out-Null
        Show-SuccessMessage "Created Brave policy registry key at $BravePolicyPath."
        Log-Message -Message "Created Brave policy registry key at $BravePolicyPath." -Level "SUCCESS"
    } catch {
        Show-ErrorMessage "Failed to create Brave policy registry key: $($_.Exception.Message)"
        Log-Message -Message "Failed to create Brave policy registry key: $($_.Exception.Message)" -Level "ERROR"
        exit 1
    }
} else {
    Show-InfoMessage "Brave policy registry key already exists at $BravePolicyPath."
    Log-Message -Message "Brave policy registry key already exists at $BravePolicyPath." -Level "INFO"
}

# ===================== PRIVACY & TELEMETRY =====================
Set-BravePolicy -Name "BraveP3AEnabled" -Value 0 -Type "DWord" -Description "Disable Brave P3A analytics"
Set-BravePolicy -Name "BraveStatsPingEnabled" -Value 0 -Type "DWord" -Description "Disable Brave stats ping"
Set-BravePolicy -Name "BraveWebDiscoveryEnabled" -Value 0 -Type "DWord" -Description "Disable Brave Web Discovery"
Set-BravePolicy -Name "PromotionsEnabled" -Value 0 -Type "DWord" -Description "Disable promotions"
Set-BravePolicy -Name "SavingBrowserHistoryDisabled" -Value 1 -Type "DWord" -Description "Disable saving browser history"
Set-BravePolicy -Name "ClearBrowsingDataOnExitList" -Value 1 -Type "DWord" -Description "Clear browsing data on exit"

# ===================== AI / MACHINE LEARNING FEATURES =====================
Set-BravePolicy -Name "BraveAIChatEnabled" -Value 0 -Type "DWord" -Description "Disable Brave AI Chat"
Set-BravePolicy -Name "BuiltInAIAPIsEnabled" -Value 0 -Type "DWord" -Description "Disable built-in AI APIs"
Set-BravePolicy -Name "GeminiSettings" -Value 0 -Type "DWord" -Description "Disable Gemini features"
Set-BravePolicy -Name "DevToolsGenAiSettings" -Value 0 -Type "DWord" -Description "Disable DevTools AI features"
Set-BravePolicy -Name "HelpMeWriteSettings" -Value 0 -Type "DWord" -Description "Disable AI writing assistance"

# ===================== SECURITY & TRACKING PROTECTION =====================
Set-BravePolicy -Name "DefaultBraveAdblockSetting" -Value 2 -Type "DWord" -Description "Enable aggressive ad blocking"
Set-BravePolicy -Name "DefaultBraveFingerprintingV2Setting" -Value 2 -Type "DWord" -Description "Strict fingerprinting protection"
Set-BravePolicy -Name "DefaultBraveHttpsUpgradeSetting" -Value 2 -Type "DWord" -Description "Force HTTPS upgrades"
Set-BravePolicy -Name "DefaultBraveReferrersSetting" -Value 2 -Type "DWord" -Description "Strict referrer trimming"
Set-BravePolicy -Name "BraveTrackingQueryParametersFilteringEnabled" -Value 1 -Type "DWord" -Description "Strip tracking query parameters"
Set-BravePolicy -Name "WebRtcIPHandling" -Value 3 -Type "DWord" -Description "Prevent WebRTC IP leaks"
Set-BravePolicy -Name "DeletingUndecryptablePasswordsEnabled" -Value 1 -Type "DWord" -Description "Delete undecryptable passwords"
Set-BravePolicy -Name "DynamicCodeSettings" -Value 0 -Type "DWord" -Description "Disable dynamic code execution"

# ===================== NETWORK & DNS SECURITY =====================
Set-BravePolicy -Name "DnsOverHttpsMode" -Value 2 -Type "DWord" -Description "Force DNS over HTTPS"
Set-BravePolicy -Name "BuiltInDnsClientEnabled" -Value 1 -Type "DWord" -Description "Enable built-in DNS client"
Set-BravePolicy -Name "EncryptedClientHelloEnabled" -Value 1 -Type "DWord" -Description "Enable TLS Encrypted Client Hello"
Set-BravePolicy -Name "HttpsOnlyMode" -Value 1 -Type "DWord" -Description "Force HTTPS-only mode"
Set-BravePolicy -Name "QuicAllowed" -Value 0 -Type "DWord" -Description "Disable QUIC protocol"

# ===================== COOKIES & STORAGE =====================
Set-BravePolicy -Name "BlockThirdPartyCookies" -Value 1 -Type "DWord" -Description "Block third-party cookies"
Set-BravePolicy -Name "DefaultCookiesSetting" -Value 2 -Type "DWord" -Description "Block cookies by default"

# ===================== WEB TECHNOLOGY CONTROLS =====================
Set-BravePolicy -Name "Disable3DAPIs" -Value 1 -Type "DWord" -Description "Disable WebGL / 3D APIs"
Set-BravePolicy -Name "SharedArrayBufferUnrestrictedAccessAllowed" -Value 0 -Type "DWord" -Description "Disable SharedArrayBuffer unrestricted access"
Set-BravePolicy -Name "DefaultWebUsbGuardSetting" -Value 2 -Type "DWord" -Description "Block WebUSB"
Set-BravePolicy -Name "DefaultWebHidGuardSetting" -Value 2 -Type "DWord" -Description "Block WebHID"
Set-BravePolicy -Name "DefaultSerialGuardSetting" -Value 2 -Type "DWord" -Description "Block Serial"
Set-BravePolicy -Name "DefaultWebBluetoothGuardSetting" -Value 2 -Type "DWord" -Description "Block WebBluetooth"

# ===================== EXTENSIONS MANAGEMENT =====================
Set-BravePolicy -Name "ExtensionDeveloperModeSettings" -Value 1 -Type "DWord" -Description "Enable extension developer mode"
Set-BravePolicy -Name "BlockExternalExtensions" -Value 0 -Type "DWord" -Description "Allow external extensions"
Set-BravePolicy -Name "NativeMessagingBlocklist" -Value "*" -Type "String" -Description "Block all native messaging hosts"

# ===================== ACCOUNT & SYNC SETTINGS =====================
Set-BravePolicy -Name "SyncDisabled" -Value 1 -Type "DWord" -Description "Disable Brave Sync"
Set-BravePolicy -Name "BrowserSignin" -Value 0 -Type "DWord" -Description "Disable browser sign-in UI"
Set-BravePolicy -Name "BrowserGuestModeEnabled" -Value 0 -Type "DWord" -Description "Disable Guest mode"

# ===================== BRAVE PRODUCT FEATURES =====================
Set-BravePolicy -Name "BraveWalletDisabled" -Value 1 -Type "DWord" -Description "Disable Brave Wallet"
Set-BravePolicy -Name "BraveVPNDisabled" -Value 1 -Type "DWord" -Description "Disable Brave VPN"
Set-BravePolicy -Name "BraveRewardsDisabled" -Value 1 -Type "DWord" -Description "Disable Brave Rewards"
Set-BravePolicy -Name "BraveNewsDisabled" -Value 1 -Type "DWord" -Description "Disable Brave News"
Set-BravePolicy -Name "AdsSettingForIntrusiveAdsSites" -Value 2 -Type "DWord" -Description "Block intrusive ads"
Set-BravePolicy -Name "BraveTalkDisabled" -Value 1 -Type "DWord" -Description "Disable Brave Talk"

# ===================== AUTOFILL & PASSWORD MANAGEMENT =====================
Set-BravePolicy -Name "AutoFillEnabled" -Value 0 -Type "DWord" -Description "Disable all autofill"
Set-BravePolicy -Name "AutofillAddressEnabled" -Value 0 -Type "DWord" -Description "Disable address autofill"
Set-BravePolicy -Name "AutofillCreditCardEnabled" -Value 0 -Type "DWord" -Description "Disable credit card autofill"
Set-BravePolicy -Name "PasswordManagerEnabled" -Value 0 -Type "DWord" -Description "Disable password manager"
Set-BravePolicy -Name "PasswordManagerBlocklist" -Value "*" -Type "String" -Description "Block all password autofill"

# ===================== USER INTERFACE & APPEARANCE =====================
Set-BravePolicy -Name "BrowserThemeColor" -Value "#24273a" -Type "String" -Description "Set browser theme color"
Set-BravePolicy -Name "BookmarkBarEnabled" -Value 1 -Type "DWord" -Description "Enable bookmark bar"
Set-BravePolicy -Name "EditBookmarksEnabled" -Value 1 -Type "DWord" -Description "Enable bookmark editing"
Set-BravePolicy -Name "ShowHomeButton" -Value 1 -Type "DWord" -Description "Show home button"
Set-BravePolicy -Name "NTPCardsVisible" -Value 0 -Type "DWord" -Description "Hide NTP cards"
Set-BravePolicy -Name "NTPCustomBackgroundEnabled" -Value 0 -Type "DWord" -Description "Disable NTP custom backgrounds"

# --- End of Policy Setup ---
Show-InfoMessage "Edge policies have been configured. Please restart Windows to apply changes."
Log-Message -Message "Edge policies have been configured. Please restart Windows to apply changes." -Level "INFO"

Write-Host ""
Prompt-UserContinue

Winfig-Banner
Write-SectionHeader -Title "Setting up Brave Browser Extensions"

Install-BraveExtension

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
