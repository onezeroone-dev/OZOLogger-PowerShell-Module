# OZOLogger PowerShell Module Installation and Usage

## Description
Provides a simple means of logging to the Windows Event Log from PowerShell scripts.

## Installation
This module is published to [PowerShell Gallery](https://learn.microsoft.com/en-us/powershell/scripting/gallery/overview?view=powershell-5.1). Ensure your system is configured for this repository then execute the following in an _Administrator_ PowerShell:

`Install-Module OZOLogger`

## Usage
Import this module in your script or console to make the functions available for use:

`Import-Module OZOSLogger`

## Functions

- [New-OZOLogger](#new-ozologger)

### New-OZOLogger
#### Description
Returns an OZOLogger object.
#### Syntax
```
New-OZOLogger
```
#### Examples
```powershell
$loggerObject = New-OZOLogger
```
#### Parameters
|Parameter|Description|
|---------|-----------|
|``||

#### Outputs
`PSCustomObject`

## Classes

- [OZOLogger](ozologger)

### OZOLogger
#### Properties
#### Methods