## Meath00k setup

Place the meath00k DLL in the DOOM Eternal game directory, then set your Steam Launch options to:
```
WINEDLLOVERRIDES="XINPUT1_3=n,b" %command%
````

Add any additional game arguments after the `%command%` section.

## EntityHero Setup

[EntityHero](https://github.com/nopjne/EntityHero "EntityHero") is a tool to edit Doom Eternal's .entities files. To use all of its features, like the meath00k integration, first make sure you got meath00k working.

Then, create a script called "EntityHero.sh" with the following commands:
```
#!/usr/bin/env bash

protonPath="/home/user/.steam/root/compatibilitytools.d/ProtonGE/proton"

if [ $openEntityHero == "1" ]; then
"${protonPath}" run EntityHero\ v0.7.exe &>/dev/null &
fi

WINEDLLOVERRIDES="XINPUT1_3=n,b" "${protonPath}" run DOOMEternalx64vk.exe &>/dev/null &
```
Add any game arguments you use after the `%command%` section.

Change the protonPath variable to match the proton binary you are using. Make sure to make the script executable by running 
```
chmod +x EntityHero.sh
```
in the current dir.

Then, set the following as your Steam launch options:
```
openEntityHero=0 ./EntityHero.sh %command% >/dev/null
```


Now, if you ever want to launch EntityHero alongside the game, just change openEntityHero value from 0 to 1 in the launch options.
