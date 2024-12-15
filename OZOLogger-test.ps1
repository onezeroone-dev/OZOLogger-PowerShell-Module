Import-Module -Name (Join-Path -Path $PSScriptRoot -ChildPath "OZOLogger")

$ozoLoggerObject = New-OZOLogger
#$ozoLoggerObject.SetConsoleOutput("off")
$ozoLoggerObject.Write("This is an informational message.","Information")
$ozoLoggerObject.Write("This is a warning message.","Warning")
$ozoLoggerObject.Write("This is an error message.","Error")
