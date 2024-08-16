# Introduction

NOTE: Given that TukUI has combined all the versions of ElvUI into a single zip file and now have an easy to use and convenient tool to check and update it, I don't really feel a need to maintain this any longer and am archving it. No further development work will be done.

This PowerShell module is designed to work with the World of Warcraft AddOn website: [TukUI.org](https://www.tukui.org/welcome.php). It allows for easy and seemless installations of addons and specifically has functions for installing addons in all three versions of the game: Retail, Wrath of the Lich King, and Classic. This module is a pet project of mine I work on in my free time, when not working on playing World of Warcraft itself!

<font color=blue><strong>This PowerShell module is a work in progress. Many functions work well, but there is lots of room for improvement.</strong></font>

## Getting Started

To use this module, simply use 'git clone' into a directory on your $PSModulePath.

Typical paths are:

* PowerShell Core: C:\Users\yourID\Documents\PowerShell\modules\
* PowerShell Desktop: C:\Users\yourID\Documents\WindowsPowerShell\modules\

To use this module, use the 'Import-Module' cmdlet:

```PowerShell
Import-Module TukUI-ps\TukUI\TukUI.psd1
```

## Practical usage

When you first import the module it will create a 'config' file and attempt to determine where your World of Warcraft base installation folder is. This folder contains subfolders for each edition of the game installed. This config file is used to determine where addons are installed and ensure you get the right version of an addon for your installations.

If you know the name of the addon you need you can simply run the following to install it directly from TukUI.org

```PowerShell
Install-TukAddon -Name <addonname> -WoWEdition [Classic|WotLK|Retail]
```

When installing an addon, a metadata.json file is generated in the addon folder. This file contains information about the currently installed version of the addon. If you re-run the same command, it will detect the version (recorded in metadata.json) installed as well as when, and compare it against the available version on TukUI.org to determine if an update is necessary. If the currently installed version is the same as the version from TukUI.org, it will not attempt to reinstall it. If they are different, the command will download the new version, remove the previous version, and install the new one.

## TO-DO's

* Configuration creation enhancements to make generation easier and more consistent.
* Create a build process to create the publishable module
* Publish module to the [PowerShell Gallery](https://www.powershellgallery.com/)

## Contribute

TODO: Explain how other users and developers can contribute to make your code better.

If you want to learn more about creating good readme files then refer the following [guidelines](https://docs.microsoft.com/en-us/azure/devops/repos/git/create-a-readme?view=azure-devops). You can also seek inspiration from the below readme files:

* [ASP.NET Core](https://github.com/aspnet/Home)
* [Visual Studio Code](https://github.com/Microsoft/vscode)
* [Chakra Core](https://github.com/Microsoft/ChakraCore)
