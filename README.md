# OZOLogger PowerShell Module Installation and Usage

## Description
Provides a simple method for logging to the Windows Event Log from PowerShell scripts.

## [Optional\] Prerequisites
Install and run the [OZO Windows Event Log Provider Setup](https://github.com/onezeroone-dev/OZO-Windows-Event-Log-Provider-Setup/blob/main/README.md) script as _Administrator_ to support the optimal use of this module. When the _One Zero One_ provider is available, messages are written to _Event Viewer > Applications and Services Logs > One Zero One > Operational_ using the desired event ID. Otherwise, messages are written to _Event Viewer > Services and Applications Logs > Microsoft > Windows > PowerShell > Operational_ as _Information_ events using event ID 4100.

## Installation
This module is published to [PowerShell Gallery](https://learn.microsoft.com/en-us/powershell/scripting/gallery/overview?view=powershell-5.1). Ensure your system is configured for this repository then execute the following in an _Administrator_ PowerShell:

`Install-Module OZOLogger`

## Usage
Import this module in your script or console to make the functions available for use:

`Import-Module OZOLogger`

## Functions
### New-OZOLogger
#### Description
Returns an object of the `OZOLogger` class. The class contains a _Write_ method that is used to write messages to the provider. See [examples](examples) and [OZOLogger](ozologger) (below) for more details.
#### Syntax
```
New-OZOLogger
```
#### Examples
```powershell
Import-Module OZOLogger
$ozoLoggerObject = New-OZOLogger
$ozoLoggerObject.Write("This is a test message.","Information")
```
#### Outputs
`PSCustomObject`

## Classes
### OZOLogger
Calling the `New-OZOLogger` function returns an object of the `OZOLogger` class. This class contains one public property and two public methods.
#### Properties

|Property|Type|Description|
|--------|----|-----------|
|`$writeOutput`|Boolean|Determines whether or not messages are written to the [user-interactive\] console.|

#### Methods
|Method|Type|Description|
|------|----|-----------|
|`Write([String]$Message,[String]$Level)`|Void|When the _One Zero One_ provider is available, _Message_ is written to the provider using the desired _Level_. Otherwise, _Level_ is ignored and _Message_ is written to the _Microsoft-Windows-PowerShell_ provider using event ID 4100.|
|`SetConsoleOutput([String]$Setting)`|Void|Controls the output of messages to the [user-interactive\] console. _Setting_ may be "on" or "off". Defaults to "on".|
