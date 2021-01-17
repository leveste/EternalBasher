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

moveOverrides(){
	# Backup previous overrides folder
	mv "${gamedir}overrides" "${gamedir}overrides_backup"

	if [[ "$replace" -eq 1 ]]
	then
		yes | cp -r "${scriptdir}overrides" "$gamedir"
	else
		cp -ir "${scriptdir}overrides" "$gamedir"
	fi

	rm -rf "${scriptdir}overrides"

	printf "\nThe overrides folder has been created and moved successfully.\n"

	exit
}



export scriptdir=""
export gamedir="$HOME/.local/share/Steam/steamapps/common/DOOMEternal/"

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

# Unzip mods to overrides folder
while [[ "$#" -gt 0 ]]
do
	unzip "$1" -d "${scriptdir}overrides"
	shift
done

# Delete non-directory contents from overrides. Folders and their respective contents remain intact.
find "${scriptdir}overrides" -maxdepth 1 -type f -exec rm -fv {} \;

# Move all folders up one level and delete original parent
(
cd "${scriptdir}overrides" || return
mkdir ../temp/
mv ./*/* ../temp/
rm -rf ./*
mv ../temp/* .
rm -rf ../temp/
)

# Decompress .entities
find "${scriptdir}overrides/maps/game" -name "*.entities" -exec wine "${scriptdir}idFileDecompressor" -d {} \;

# Ask user if he wishes to move overrides folder
read -rp "Would you like to move the overrides folder to the DOOMEternal folder? Press 'Y' to accept, press any other key to continue." response

if [[ "$response" == [yY] ]]
then
	moveOverrides
else
	printf "Overrides folder was created succesfully, you can find it on %s." "$scriptdir"
fi
