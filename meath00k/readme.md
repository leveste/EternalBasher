## Meath00k setup

Meath00k is a tool that implements various utilities into the game for modding purposes.

First, you can get meath00k from the latest [EntityHero](https://github.com/nopjne/EntityHero "EntityHero") release. Extract the XINPUT1\_3.dll file in the "meathook_interface" folder to your DOOMEternal folder.

You will need to set the wine prefix to pfx and launch *winecfg*. Simply type the following in the terminal (replace "user" with your username)

    WINEPREFIX=/home/user/.local/share/Steam/steamapps/compatdata/782330/pfx/ winecfg

Once you have winecfg open, go into the "Libraries" tab and add XINPUT1\_3.dll so it uses meathook instead of the default DLL.

## EntityHero Setup

[EntityHero](https://github.com/nopjne/EntityHero "EntityHero") is a tool to edit Doom Eternal's .entities files. To use all of its features, like the meath00k integration, first make sure you got meath00k working.

Then, create a script called "EntityHero.sh" with the following commands:
```
#!/usr/bin/env bash

protonPath="/home/user/.steam/root/compatibilitytools.d/ProtonGE/proton"

if [ $openEntityHero == "1" ]; then
"${protonPath}" run EntityHero\ v0.7.exe &>/dev/null &
fi

"${launchOptions}" "${protonPath}" run DOOMEternalx64vk.exe "${gameArguments}" &>/dev/null &
```

Change the protonPath variable to match the proton binary you are using. Make sure to make the script executable by running 
```
chmod +x EntityHero.sh
```
in the current dir.

Then, set the following as your Steam launch options:
```
openEntityHero=0 launchOptions="" gameArguments="" ./EntityHero.sh %command% >/dev/null
```
Change the launchOptions and gameArguments to whatever you use before the %command% normally, and gameArguments to the other part. For example if you normally have the following Steam launch options:
```
_GL_SHADER_DISK_CACHE=1 __GL_SHADER_DISK_CACHE_SKIP_CLEANUP=1 _GL_SHADER_DISK_CACHE_PATH=/home/user/shaders %command% +in_terminal 1 +com_skipIntroVideo 1 +com_skipKeyPressOnLoadScreens 1 +com_skipSignInManager 1
```
Then you would put:
```
openEntityHero=0 launchOptions="_GL_SHADER_DISK_CACHE=1 __GL_SHADER_DISK_CACHE_SKIP_CLEANUP=1 _GL_SHADER_DISK_CACHE_PATH=/home/user/shaders" gameArguments="+in_terminal 1 +com_skipIntroVideo 1 +com_skipKeyPressOnLoadScreens 1 +com_skipSignInManager 1" ./EntityHero.sh %command% >/dev/null
```
Now, if you ever want to launch EntityHero alongside the game, just change openEntityHero value from 0 to 1 in the launch options.
