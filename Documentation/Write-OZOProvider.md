# Write-OZOProvider
This function is part of the [OZOLogger PowerShell Module](https://github.com/onezeroone-dev/OZOLogger-PowerShell-Module/blob/main/README.md).

## Description
Provides a simpler (but less flexible) way to write to the One Zero One Windows Event Log provider (as compared the [New-OZOLogger](New-OZOLogger.md) method).

## Syntax
```
Write-OZOProvider
    -Message
    -Level
```

## Parameters
|Parameter|Description|
|---------|-----------|
|`Message`|The message to write to the event.|
|`Level`|The message level. When used with the [_One Zero One_ provider](https://www.powershellgallery.com/packages/ozo-windows-event-log-provider-setup), allowed values are _Information_, _Warning_, and _Error_. If you provide an invalid value, or if you have not implemented the _One Zero One_ event log provider, messages are written as Information events.|

## Examples
## Example 1
`````powershell
Write-OZOProvider -Message "This is an informational message" -Level "Information"
`````

## Example 2
`````powershell
Write-OZOProvider -Message "This is a warning message" -Level "Warning"
`````

## Example 3
`````powershell
Write-OZOProvider -Message "This is an error message" -Level "Error"
`````

## Reviewing Events
See [Optional Prerequisite](../README.md#optional-prerequisite) and [Reviewing Events](../README.md#reviewing-events).
