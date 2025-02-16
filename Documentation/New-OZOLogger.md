# New-OZOLogger
This function is part of the [OZOLogger PowerShell Module](https://github.com/onezeroone-dev/OZOLogger-PowerShell-Module/blob/main/README.md).

## Description
Returns an object of the `OZOLogger` class. The class contains a _Write_ method for writing events to the provider. See [examples](#examples) for more details.

## Syntax
```
New-OZOLogger
```

## Examples
```powershell
Import-Module OZOLogger
$ozoLoggerObject = New-OZOLogger
$ozoLoggerObject.Write("This is a test message.","Information")
```

## Outputs
`PSCustomObject`

## Reviewing Events
See [Optional Prerequisite](../README.md#optional-prerequisite) and [Reviewing Events](../README.md#reviewing-events).