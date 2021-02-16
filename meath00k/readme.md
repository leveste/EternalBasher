Meath00k setup
============

First, you can get meath00k from the latest EntityHero release. Extract the XINPUT1\_3.dll file in the "meathook_interface" folder to your DOOMEternal folder.

You will need to set the wine prefix to pfx and launch *winecfg*. Simply type the following in the terminal (replace "user" with your username)

    WINEPREFIX=/home/user/.local/share/Steam/steamapps/compatdata/782330/pfx/ winecfg

Once you have winecfg open, go into the "Libraries" tab and add XINPUT1\_3.dll so it uses meathook instead of the default DLL.

-----------------------------------
