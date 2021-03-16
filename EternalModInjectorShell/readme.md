# EternalModInjector Shell

Tool for installing mods for Doom Eternal on Linux.

Made by **Leveste** and **PowerBall253**.

Based on the original batch file by **Zwip-Zwap Zapony**.

## Instructions:

* Validate you game files. **Right click on Doom Eternal in your Steam Library** -> **Properties** -> **Local files** -> **View integrity of game files...**

* Download the modding tools. You can get the tools from the latest release. The tools have been updated to run natively on Linux.

* Place the modding tools and shell script in your Doom Eternal folder. **Right click on Doom Eternal** -> **Manage** -> **Browse local files**

* Make the file executable. You can do so with the following command: **chmod +x EternalModInjectorShell.sh**. Depending on your desktop environment, you can also right click on the file and change the permissions from properties.

* Run the file. If you have the zip file for a mod in your **Mods** folder, it will install the mod. To remove all mods, just empty you **Mods** folder and run the file again.

You can download mods from [NexusMods](https://www.nexusmods.com/doometernal) or check the [Doom 2016+ Modding Discord](https://discord.com/channels/570112501853978624/614488711572357120).

## Reporting issues

You can use the debug mode to get full output from all tools by setting the ETERNALMODINJECTOR_DEBUG environment variable to 1, like this:
```
ETERNALMODINJECTOR_DEBUG=1 ./EternalModInjectorShell.sh
```
When prompted, press y to confirm you wanna run in debug mode. This will show full output for all tools and also write it to a EternalModInjector_log.txt file.

Then, you can open an issue on this repo, providing your log file, and whatever information you consider relevant to the issue.
