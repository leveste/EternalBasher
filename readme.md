Collection of bash scripts for different aspects of Doom Eternal modding. Further instructions can be found in the readme file of each one.

------------------------

**Auto Heckin' Textrure Converter**

Automatically converts any texture file(s) to the TGA format required by the game, eliminating the need of using Nvidia's tool to convert to BC1a and then DivinityMashine. manually.

**DEternal_patchManifest**

Patches the build-manifest.bin file for modding purposes. Compiled for Linux from SutandoTsukai's script using PyInstaller.

**EternalExtractor**

Script for automating the process of running QuickBMS to extract all of DOOM Eternal's \*.resources archives.

**EternalModInjector Shell**

Helps with installing Doom Eternal mods.

**EternalPatcherCLI**

Modified version of proteh's EternalPatcher (a tool to apply various patches to the game executable for modding purposes), removing the GUI to make it compatible with Mono.

**ModLoader_to_MeatHook**

Meath00k is a dll that allows the user to override "\*.entities" files with your own decompressed and modified files. You don't need to restart the game after editing the file. Loading a checkpoint should be enough. This script converts mods made for the ModLoader to an "overrides" to use with meath00k, and then moves it to the Doom Eternal folder.

**idFileDeCompressor_Auto**

Simplifies the use of proteh's idFileDecompressore tool. Used to modify .entities files.

**idRehashLinux**

Modified version of infogram and proteh's idRehash (a tool to hash the resource offsets and store them in meta.resources to allow loading of custom .resources) to work natively on Linux.

**meath00k**

Readme explaining how to use chrispy's meath00k and Scorp's EntityHero on Linux.
