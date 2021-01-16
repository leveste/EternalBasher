#!/bin/bash
export script=""
script="/home/leveste/.local/share/Steam/steamapps/common/DOOMEternal/doometernal.bms"
export quickbms="/home/leveste/Descărcări/"
#wine "/home/leveste/Descărcări/quickbms_4gb_files.exe" -o -Y
if [[ "$1" -eq 1 ]]
then
	find .  -name "*.resources" -exec sh -c 'wine "quickbms_4gb_files.exe" -o -Y "$script" "$1" "/home/leveste/Documente/EternalOutput/"' sh {} \;
fi

