# Introduction

This PowerShell module is designed to work with the World of Warcraft AddOn website: TukUI.org. It allows for easy and seemless installations of addons and specifically has functions for installing addons in both Retail and Classic versions of the game.

## Getting Started

To use this module, simply use 'git clone' into a directory on your $PSModulePath.

Typical paths are:

* PowerShell Core: C:\Users\yourID\Documents\PowerShell\modules\
* PowerShell Desktop: C:\Users\yourID\Documents\WindowsPowerShell\modules\

To use this module, use the 'Import-Module' cmdlet:

```PowerShell
Import-Module TukUI
```

## Functions included

|Name|What it does|Notes|
|----|------------|-----|
|Get-TUKAddon|Downloads an addon from the website||
|Get-TUKAddonList|Returns a list of available addons and optionally allows you to find specific addons||
|New-TUKConfig|Creates the configuration file with details about your World of Warcraft installations||
|Get-TUKConfig|Returns a hashtable with the contents of your config file||
|New-TUKConfigWoWInstallation|Used to find World of Warcraft installations||
|Install-ElvUI|Script that specifically allows for the installation of the ElvUI addon||

## Contribute

TODO: Explain how other users and developers can contribute to make your code better.

If you want to learn more about creating good readme files then refer the following [guidelines](https://docs.microsoft.com/en-us/azure/devops/repos/git/create-a-readme?view=azure-devops). You can also seek inspiration from the below readme files:

* [ASP.NET Core](https://github.com/aspnet/Home)
* [Visual Studio Code](https://github.com/Microsoft/vscode)
* [Chakra Core](https://github.com/Microsoft/ChakraCore)