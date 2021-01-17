#!/bin/bash

# Check for config file
CreateConfig(){
	read -rp "The default DOOM Eternal folder is set to '$gamedir'. Press 'Y' if you wish to change it. Press any other key to continue with this setting. " response
	printf "\n\n"
	if [[ $response == [yY] ]]
	then
		read -rp "Please input you DOOM Eternal directory. Make sure to provide the full path: " gamedir
	fi

	echo "GAMEDIR=${gamedir}" >> "ModLoader_to_Meathook.cfg"
    read -r -p "Would you like this batch to automatically overwrite files when copying the overrides folder every time you use it? [y/N]" response

    case "$response" in
        [yY][eE][sS]|[yY])
               echo "REPLACE=${response}" >> "ModLoader_to_Meathook.cfg"
        ;;
    *)
            echo "REPLACE=${response}" >> "ModLoader_to_Meathook.cfg"
        ;;
    esac
}


scriptdir=""
gamedir="$HOME/.local/share/Steam/steamapps/common/DOOMEternal/"

# Set scriptdir and make sure it ends with \
if ! [[ $scriptdir == "*/" ]]; then scriptdir="${scriptdir}/"; fi

# Check for config file
if ! [ -f ModLoader_to_Meathook.cfg ]; then CreateConfig; else

    if grep -sq ":REPLACE=1" "$CONFIG_FILE"; then replace="1"; else replace="0"; fi
fi

# Check for idFileDecompressor
if ! [ -f "${scriptdir}idFileDeCompressor.exe" ]
then
	printf "idFileDeCompressor was not found! Put idFileDecompressor.exe in the same folder as this batch, then try again."
fi

# Check for oo2core_8_win64.dll
if ! [ -f "${scriptdir}oo2core_8_win64.dll" ]
then
	printf "oo2core_8_win64.dll was not found! Put oo2core_8_win64.dll in the same folder as this batch, then try again."
fi

# Remove previous overrides folder
rm -rf "${scriptdir}overrides"
