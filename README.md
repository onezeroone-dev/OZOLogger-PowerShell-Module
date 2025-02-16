# OZOLogger PowerShell Module Installation and Usage

## Description
Provides a simple method for logging to the Windows Event Log from PowerShell scripts.

## Optional Prerequisite
Install and run the [OZO Windows Event Log Provider Setup](https://www.powershellgallery.com/packages/ozo-windows-event-log-provider-setup) script as _Administrator_ to implement the _One Zero One_ provider which allows the optimal use of this module.

## Installation
This module is published to [PowerShell Gallery](https://learn.microsoft.com/en-us/powershell/scripting/gallery/overview?view=powershell-5.1). Ensure your system is configured for this repository then execute the following in an _Administrator_ PowerShell:

```powershell
Install-Module OZOLogger
```

## Usage
Import this module in your script or console to make the functions available for use:

```powershell
Import-Module OZOLogger
```

## Functions
- [New-OZOLogger](Documentation/New-OZOLogger.md)
- [Write-OZOProvider](Documentation/Write-OZOProvider.md)

## Classes
- [OZOLogger](Documentation/OZOLogger%20Class.md)

## Reviewing Events
Open Windows _Event Viewer_ to review events. When the [_One Zero One_ provider is available](https://www.powershellgallery.com/packages/ozo-windows-event-log-provider-setup), events are written to _Applications and Services Logs > One Zero One > Operational_ using _Information_ (1000), _Warning_ (1001), or _Error_ (1002) events.

Otherwise, messages are written to _Services and Applications Logs > Microsoft > Windows > PowerShell > Operational_ as _Information_ (4100) events.