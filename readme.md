Collection of bash scripts for different aspects of Doom Eternal modding. Further instructions can be found in the readme file of each one.

------------------------

**Auto Heckin' Textrure Converter**

Automatically converts any texture file(s) to the TGA format required by the game, eliminating the need of using Nvidia's tool to convert to BC1a and then DivinityMashine. manually.

**DOOMSaveManagerLinux**

A program to make importing and exporting DOOM saves easier, modified to work for Linux using Mono.

**EternalBins**

Collection of compiled native binaries of modding tools.

**EternalExtractor**

Script for automating the process of running QuickBMS to extract all of DOOM Eternal's \*.resources archives.

**EternalModInjector Shell**

Script that automatically installs mods using the rest of the tools.

**EternalModLoaderCpp**

Tool to load mods into Doom Eternal's .resources files, rewritten on C++ for Linux.

**EternalPatchManifest Rust**

Tool that patches the build-manifest.bin file for modding purposes, rewritten on Rust for Linux.

**EternalPatcherCpp**

Tool that patches the DOOM Eternal executable for modding purposes, rewritten on C++ for Linux.

**ModLoader_to_MeatHook**

Meath00k is a dll that allows the user to override "\*.entities" files with your own decompressed and modified files. You don't need to restart the game after editing the file. Loading a checkpoint should be enough. This script converts mods made for the ModLoader to an "overrides" to use with meath00k, and then moves it to the Doom Eternal folder.

**idFileDeCompressor_Auto**

Simplifies the use of proteh's idFileDecompressore tool. Used to modify .entities files.

**idRehashLinux**

Modified version of infogram and proteh's idRehash (a tool to hash the resource offsets and store them in meta.resources to allow loading of custom .resources) to work natively on Linux.

**idSaveDecompressorLinux**

Tool for decompressing DOOM Eternal saved games (game_duration.dat) adapted to work on Linux using Mono.

**meath00k**

Readme explaining how to use chrispy's meath00k and Scorp's EntityHero on Linux.
