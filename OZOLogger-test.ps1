Import-Module -Name (Join-Path -Path $PSScriptRoot -ChildPath "OZOLogger")

$ozoLoggerObject = New-OZOLogger
#$ozoLoggerObject.SetConsoleOutput("off")
$ozoLoggerObject.Write("This is an informational message written with an OZOLogger object.","Information")
$ozoLoggerObject.Write("This is a warning message written with an OZOLogger object.","Warning")
$ozoLoggerObject.Write("This is an error message written with an OZOLogger object.","Error")

Write-OZOProvider -Message "This is an informational message written with Write-OZOProvider." -Level "Information"
Write-OZOProvider -Message "This is a warning message written with Write-OZOProvider." -Level "Warning"
Write-OZOProvider -Message "This is an error message written with Write-OZOProvider." -Level "Error"
