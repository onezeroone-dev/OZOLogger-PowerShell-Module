# Write-OZOProvider
This function is part of the [OZOLogger PowerShell Module](https://github.com/onezeroone-dev/OZOLogger-PowerShell-Module/blob/main/README.md).

## Description
Provides a simpler (but less flexible) way to write to the One Zero One Windows Event Log provider versus the [New-OZOLogger](New-OZOLogger.md) method.

## Syntax
```
Write-OZOProvider
    [-Level]
    -Message
    [-WriteToConsole]
```

## Parameters
|Parameter|Description|
|---------|-----------|
|`Level`|The message level. Allowed values are _Success_, _Information_, _Warning_, and _Error_. Invalid values will be handed as _Information_ events. Defaults to _Information_.|
|`Message`|The message to write to the event provider.|
|`WriteToConsole`|When specified, messages will be written to the console in addition to the provider.|

## Examples
## Example 1
`````powershell
Write-OZOProvider -Message "This is a success message" -Level "Success"
`````

## Example 2
`````powershell
Write-OZOProvider -Message "This is an information message" -Level "Information"
`````

## Example 3
`````powershell
Write-OZOProvider -Message "This is a warning message" -Level "Warning"
`````

## Example 4
`````powershell
Write-OZOProvider -Message "This is an error message" -Level "Error"
`````

## Reviewing Events
See [optional prerequisite](../README.md#optional-prerequisite) and [reviewing events](../README.md#reviewing-events).
