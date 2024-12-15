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
    return [OZOLogger]::new((Split-Path -Path $MyInvocation.ScriptName -Leaf))
}

Export-ModuleMember New-OZOLogger
