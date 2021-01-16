#!/bin/bash
export script=""
script="/home/leveste/.local/share/Steam/steamapps/common/DOOMEternal/doometernal.bms"
export quickbms="/home/leveste/Descărcări/quickbms_4gb_files.exe"
#wine "/home/leveste/Descărcări/quickbms_4gb_files.exe" -o -Y
if [[ "$1" -eq 1 ]]
then
	find "/home/leveste/.local/share/Steam/steamapps/common/DOOMEternal/" -name "*.resources" -exec sh -c 'wine "$quickbms" -o -Y "$script" "$1" "/home/leveste/Documente/EternalOutput/"' sh {} \;
fi

