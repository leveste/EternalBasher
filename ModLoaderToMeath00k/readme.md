Meath00k is a dll that allows the user to override "\*.entities" files with your own decompressed and modified files. You don't need to restart the game after editing the file. Loading a checkpoint should be enough.

Prerequisites
===============

Before running the tool, you'll need to make sure to have [idFileDeCompressor](https://discord.com/channels/570112501853978624/693113846688383029/747181445092605973) and oo2core\_8\_win64.dll(found in the DOOM Eternal folder) in the same directory as the script.

To get Meath00k, simply download the latest [Entity Hero release](https://github.com/nopjne/EntityHero). You can find the dll in the *meathook_interface* folder(under the name **XINPUT1_3.dll**). Simply paste it in your DOOM Eternal folder.

Wine is also a prerequisite.

Instructions
============

First make the file executable

    chmod +x ModLoader_to_MeatHook.sh

Depending on your distro or desktop environment, you can also do this by right-clicking the file and going into properties.

To run the script, type:

    ./ModLoader_to_MeatHook.sh

##Meath00k Wine prefix

You will need to set the wine prefix to pfx and launch *winecfg*. Simply type the following in the terminal(replace "user" with your username)

    WINEPREFIX=/home/user/.local/share/Steam/steamapps/compatdata/782330/pfx/ winecfg

Once you have winecfg open, go into the "Libraries" tab and add XINPUT1\_3.dll so it overrides the default one.

-----------------------------------

Made by **Leveste** and **PowerBall253**.
