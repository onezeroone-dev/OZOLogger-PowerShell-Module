Class OZOLogger {
    # PROPERTIES
    [Boolean] $writeOutput = $true
    Hidden [String] $scriptName = $null
    # METHODS
    # Constructor method
    OZOLogger($ScriptName) {
        $this.scriptName = $ScriptName
    }
    # Write method
    [Void] Write([String]$Message,[String]$Level) {
        # Set properties
        # Set default value for Id
        [Int32] $Id = 0000
        # Declare valid Levels
        [Array] $Levels = @("information","warning","error")
        # Determine if Level does not appear in Levels; and if it does not, set it to "Information"
        If ($Levels -NotContains $Level.ToLower()) { $Level = "information" }
        # Translate Level to Id
        Switch($Level.ToLower()) {
            "information" { $Id = 1000 }
            "warning"     { $Id = 1001 }
            "error"       { $Id = 1002 }
        }
        # Try to write to the One Zero One provider
        Try {
            New-WinEvent -ProviderName "One Zero One" -Id $Id -Payload $this.scriptName,$Message -ErrorAction Stop
            # Success
        } Catch {
            # Failure; write to the Microsoft-Windows-PowerShell provider instead using EventID 4100
            New-WinEvent -ProviderName "Microsoft-Windows-PowerShell" -Id 4100 $this.scriptName,'Please install the "One Zero One" Windows Event Log provider to support the optimal use of the OZOLogger module. See https://github.com/onezeroone-dev/OZO-Windows-Event-Log-Provider-Setup/blob/main/README.md for more information.',$Message -ErrorAction SilentlyContinue
        }
        # Determine if writeOutput is true AND session is user-interactive
        If ($this.writeOutput -eq $true -And [Environment]::UserInteractive -eq $true) {
            # Switch on Level to output to the console according to the Level
            Switch($Level.ToLower()) {
                "information" { Write-Host $Message }
                "warning"     { Write-Warning -Message $Message}
                "error"       { Write-Error -Message $Message}
            }
        }
    }
    # Set writeOutput method
    [Void] SetConsoleOutput([String]$Setting) {
        # Declare valid Setttings
        [Array] $Settings = @("on","off")
        # Determine if Setting does not appear in Settings; and if it does not, set it to "on"
        If ($Settings -NotContains $Setting) { $Setting = "on" }
        # Switch on Setting to set writeOutput
        Switch($Setting) {
            "on"  { $this.writeOutput = $true  }
            "off" { $this.writeOutput = $false }
        }
    }
}

Function New-OZOLogger() {
    <#
        .SYNOPSIS
        See description.
        .DESCRIPTION
        Returns an object of the OZOLogger class. The class contains a Write method for writing events to the provider.
        .EXAMPLE
        Import-Module OZOLogger
        $ozoLoggerObject = New-OZOLogger
        $ozoLoggerObject.Write("This is a test message.","Information")
        .LINK
        https://github.com/onezeroone-dev/OZOLogger-PowerShell-Module/blob/main/Documentation/New-OZOLogger.md
    #>
    # Determine if this is function has been called from the command line or from a script
    If ([String]::IsNullOrEmpty($MyInvocation.ScriptName)) {
        # Command line; instantiate the object with "Command-line input:" for %1
        return [OZOLogger]::new("Command-line input:")
    } Else {
        # Script; instantiate the object with the script name for %1
        return [OZOLogger]::new(((Split-Path -Path $MyInvocation.ScriptName -Leaf) + ":"))
    }
    
}

Function Write-OZOProvider {
    <#
        .SYNOPSIS
        See description.
        .DESCRIPTION
        Provides a simpler (but less flexible) way to write to the One Zero One Windows Event Log provider (as compared the New-OZOLogger method).
        .PARAMETER Message
        The message to write to the event.
        .PARAMETER Level
        The message level. Allowed values are Information, Warning, and Error. If you provide an invalid value, messages are written as Information events.
        .EXAMPLE
        Write-OZOProvider -Message "This is an informational message" -Level "Information"
        .EXAMPLE
        Write-OZOProvider -Message "This is a warning message" -Level "Warning"
        .EXAMPLE
        Write-OZOProvider -Message "This is an error message" -Level "Error"
    #>
    param(
        [Parameter(Mandatory=$true,HelpMessage="The message to write to the event")][String] $Message,
        [Parameter(Mandatory=$false,HelpMessage="The message level")][String] $Level = "Information"
    )
    # Initialize variables
    [String] $Source = $null
    [Int32]  $Id     = 1000
    # Switch on level to set Id
    Switch($Level) {
        "Information" { $Id = 1000 }
        "Warning"     { $Id = 1001 }
        "Error"       { $Id = 1002 }
        default       { $Id = 1000 }
    }
    # Set the script name
    If ([String]::IsNullOrEmpty($MyInvocation.ScriptName)) {
        $Source = "Command-line input:"
    } Else {
        $Source = ((Split-Path -Path $MyInvocation.ScriptName -Leaf) + ":")
    }
    # Try to write to the One Zero One provider
    Try {
        New-WinEvent -ProviderName "One Zero One" -Id $Id -Payload $Source,$Message -ErrorAction Stop | Out-Null
        # Success
    } Catch {
        # Failure; write to Microsoft-Windows-PowerShell
        New-WinEvent -ProviderName "Microsoft-Windows-PowerShell" -Id 4100 -Payload $Source,"Script output.",$Message | Out-Null
    }
}

Export-ModuleMember New-OZOLogger,Write-OZOProvider
