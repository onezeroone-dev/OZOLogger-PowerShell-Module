Class OZOLogger {
    # PROPERTIES: Booleans
    [Boolean] $writeOutput = $true
    # PROPERTIES: PSCustomObject Lists
    [System.Collections.Generic.List[PSCustomObject]] $Events = @()
    # PROPERTIES: Strings
    Hidden [String] $scriptName = $null
    # METHODS: Constructor method
    OZOLogger($ScriptName) {
        $this.scriptName = $ScriptName
    }
    # METHODS: Write method
    [Void] Write([String]$Message,[String]$Level) {
        # Set properties
        [Int32] $Id = 0000
        [Array] $Levels = @("success","information","warning","error")
        # Determine if Level does not appear in Levels; and if it does not, set it to "Information"
        If ($Levels -NotContains $Level.ToLower()) {
            # Level does not appear in Levels; set to Information
            $Level = "information"
        }
        # Translate Level to Id
        Switch($Level.ToLower()) {
            "success"     { $Id = 1000; break }
            "information" { $Id = 1000; break }
            "warning"     { $Id = 1001; break }
            "error"       { $Id = 1002; break }
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
                "success"     { Write-Host -ForegroundColor "Gree" $Message }
                "information" { Write-Host $Message }
                "warning"     { Write-Warning -Message $Message}
                "error"       { Write-Error -Message $Message}
            }
        }
        # Add this event to the Events list
        $this.Events.Add(([PSCustomObject]@{
            "Level"   = $Level
            "Message" = $Message
        }))
    }
    # METHODS: Set writeOutput method
    [Void] SetConsoleOutput([String]$Setting) {
        # Declare valid Setttings
        [Array] $Settings = @("on","off")
        # Determine if Setting does not appear in Settings; and if it does not, set it to "on"
        If ($Settings -NotContains $Setting.ToLower()) { $Setting = "on" }
        # Switch on Setting to set writeOutput
        Switch($Setting.ToLower()) {
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
        Provides a simpler way to write to the One Zero One Windows Event Log provider versus the New-OZOLogger method.
        .PARAMETER Level
        The message level. Allowed values are Success, Information, Warning, and Error. If you provide an invalid value, messages are written as Information events.
        .PARAMETER Message
        The message to write to the event.
        .PARAMETER WriteToConsole
        Write the message to the console in addition to the provider, if the session is user-interactive.
        .EXAMPLE
        Write-OZOProvider -Message "This is a success message" -Level "Success"
        .EXAMPLE
        Write-OZOProvider -Message "This is an information message" -Level "Information"
        .EXAMPLE
        Write-OZOProvider -Message "This is a warning message" -Level "Warning"
        .EXAMPLE
        Write-OZOProvider -Message "This is an error message" -Level "Error"
    #>
    [CmdLetBinding()]Param(
        [Parameter(Mandatory=$false,HelpMessage="The message level")][String] $Level = "Information",    
        [Parameter(Mandatory=$true,HelpMessage="The message to write to the event")][String] $Message,
        [Parameter(Mandatory=$false,HelpMessage="Write the message to the console")][Switch] $WriteToConsole
    )
    # Create an OZOLogger object
    [PSCustomObject] $ozoLogger = (New-OZOLogger)
    # Determine if operator did not specify WriteToConsole
    If ($WriteToConsole.IsPresent -eq $false) {
        # Operator did not specify WriteToConsole; call SetConsoleOutput "off" the ozoLogger Object
        $ozoLogger.SetConsoleOutput("off")
    }
    # Log the message
    $ozoLogger.Write($Message,$Level)
}

<#
Function Write-OZOProvider {
    [CmdLetBinding()]Param(
        [Parameter(Mandatory=$false,HelpMessage="The message level")][String] $Level = "Information",    
        [Parameter(Mandatory=$true,HelpMessage="The message to write to the event")][String] $Message,
        [Parameter(Mandatory=$false,HelpMessage="Write the message to the console")][Switch] $WriteToConsole
    )
    # Variables: Int32s
    [Int32] $Id = 1000
    # Variables: Strings
    [String] $Source = $null
    # Switch on level to set Id
    Switch($Level) {
        "Success"     { $Id = 1000; break }
        "Information" { $Id = 1000; break }
        "Warning"     { $Id = 1001; break }
        "Error"       { $Id = 1002; break }
        default       { $Id = 1000; break }
    }
    # Determine if ScriptName is not null or empty
    If ([String]::IsNullOrEmpty($MyInvocation.ScriptName) -eq $false) {
        # ScriptName is not null or empty; set Source
        $Source = ((Split-Path -Path $MyInvocation.ScriptName -Leaf) + ":")
    } Else {
        # ScriptName is null or empty; set Source
        $Source = "Command-line input:"
    }
    # Try to write to the One Zero One provider
    Try {
        New-WinEvent -ProviderName "One Zero One" -Id $Id -Payload $Source,$Message -ErrorAction Stop | Out-Null
        # Success
    } Catch {
        # Failure; write to Microsoft-Windows-PowerShell
        New-WinEvent -ProviderName "Microsoft-Windows-PowerShell" -Id 4100 -Payload $Source,"Script output.",$Message | Out-Null
    }
    # Determine if operator specified WriteToConsole and the session is user-interactive
    If ($WriteToConsole.IsPresent -eq $true -And [Environment]::UserInteractive -eq $true) {
        # Operator specified WriteToConsole and session is user interactive; Switch on $Level
        Switch($Level) {
            "Success"     {
                Write-Host -ForegroundColor "Green" $Message
                break
            }
            "Information" {
                Write-Host $Message
                break
            }
            "Warning"     {
                Write-Warning -Message $Message
                break
            }
            "Error"       {
                Write-Error -Message $Message
                break
            }
            default       {
                # Do nothing
                break
            }
        }
    }
#>

Export-ModuleMember -Function `
    New-OZOLogger,
    Write-OZOProvider
