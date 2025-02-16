## OZOLogger
This class is part of the [OZOLogger PowerShell Module](https://github.com/onezeroone-dev/OZOLogger-PowerShell-Module/blob/main/README.md).

## Usage
Call the `New-OZOLogger` function to return an object of this class; it contains one public property and two public methods.

## Properties
|Property|Type|Description|
|--------|----|-----------|
|`writeOutput`|Boolean|Determines whether or not messages are written to the [user-interactive\] console.|

## Methods
|Method|Type|Description|
|------|----|-----------|
|`Write([String]$Message,[String]$Level)`|Void|When the _One Zero One_ provider is available, _Message_ is written to the provider using the desired _Level_. Otherwise, _Level_ is ignored and _Message_ is written to the _Microsoft-Windows-PowerShell_ provider using event ID 4100.|
|`SetConsoleOutput([String]$Setting)`|Void|Controls the output of messages to the [user-interactive\] console. _Setting_ may be "on" or "off". Defaults to "on".|

## Reviewing Events
See [Optional Prerequisite](../README.md#optional-prerequisite) and [Reviewing Events](../README.md#reviewing-events).