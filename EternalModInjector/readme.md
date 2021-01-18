Tool for installing mods for Doom Eternal on Linux.

Made by **Leveste** and **PowerBall253**.

Based on the original batch file by **Zwip-Zwap Zapony**.

Instructions:
-------------

* Validate you game files. **Right click on Doom Eternal in your Steam Library** -> **Properties** -> **Local files** -> **View integrity of game files...**

* Download the modding tools. You can get them from [here.](https://discord.com/channels/570112501853978624/693113846688383029/791336903424213002) You'll also need to have Wine installed.

* Place the modding tools and shell script in your Doom Eternal folder. **Right click on Doom Eternal** -> **Manage** -> **Browse local files**

* Make the file executable. You can do so with the following command: **chmod +x EternalModInjector.sh**. Depending on your desktop environment, you can also right click on the file and change the permissions from properties.

* Run the file. If you have the zip file for a mod in your **Mods** folder, it will install the mod. To remove all mods, just empty you **Mods** folder and run the file again.

You can download mods from [NexusMods](https://www.nexusmods.com/doometernal) or check the [Doom 2016+ Modding Discord](https://discord.com/channels/570112501853978624/614488711572357120).

------------------------------

Issues
------------------------------

If you are having issues with Wine, you will need to make sure **wine-mono** is installed.

On Ubuntu-based systems(like Mint), we recommend that you install Wine from the [winehq website](https://wiki.winehq.org/Ubuntu) and run

    wine uninstaller

to confirm the package was installed.

If you are having issues with missing dlls, install the [Microsoft Visual C++ 2015-2019 Redistributable](https://support.microsoft.com/en-gb/help/2977003/the-latest-supported-visual-c-downloads) for x86. Simply download the file and run it through Wine.

    wine VC_redist.x86.exe
