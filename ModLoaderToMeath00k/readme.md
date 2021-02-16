# ModLoaderToMeath00k

Script that converts mods made for the ModLoader to an "overrides" to use with meath00k, and then moves it to the DOOMEternal folder.

## Prerequisites

Before running the tool, you'll need to make sure to have [idFileDeCompressor](https://discord.com/channels/570112501853978624/693113846688383029/747181445092605973) and oo2core\_8\_win64.dll (found in the DOOM Eternal folder) in the same directory as the script.

To get Meath00k, simply download the latest [EntityHero release](https://github.com/nopjne/EntityHero). You can find the dll in the *meathook_interface* folder(under the name **XINPUT1_3.dll**). Simply paste it in your DOOM Eternal folder, then refer to the meath00k readme for setup.

Wine is also a prerequisite.

## Instructions

First make the file executable

    chmod +x ModLoader_to_MeatHook.sh

Depending on your distro or desktop environment, you can also do this by right-clicking the file and going into properties.

To run the script, type:

    ./ModLoader_to_MeatHook.sh mod1.zip mod2.zip
    

Made by **Leveste** and **PowerBall253**.
