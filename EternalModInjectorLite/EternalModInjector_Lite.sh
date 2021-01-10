printf "EternalModInjector Shell Script\n\n
		By Leveste and PowerBall253\n\n
		Based on original batch file by Zwip-Zwap Zapony\n\n\n"

#Functions
MissingGame() {
read -p "
	Game Executable not found! Make sure you put this shell script in the DOOMEternal folder and try again.
	"
exit 1
}

MissingDEternalLoadMods() {
read -p "
	DEternal_loadMods not found or corrupted! Re-extract the tool to the DOOMEternal folder and try again.
	"
exit 1
}

MissingIdRehash() {
read -p "
	idRehash not found or corrupted! Re-extract the tool to the DOOMEternal/base folder and try again.
	"
exit 1
}

# ModLoader function
ModLoader(){
	echo "Restoring .resources archives..."
	FunctionCallForResources FunctionBackUpOrRestoreArchive
	if [[ $? != 0 ]];then exit 1;fi

	printf "\nGetting Vanilla resource hash offsets... (idRehash)"
	exec wine "./base/idRehash.exe" "--getoffsets"

}

if ! [ -f DOOMEternalx64vk.exe ]; then MissingGame; fi
if ! [ -f DEternal_loadMods.exe ]; then MissingDEternalLoadMods; fi
if ! [ -f base/idRehash.exe ]; then MissingIdRehash; fi


printf "Please choose what you want to do.
		
	(Deleting backups is necessary after vanilla game updates, but should only be done after you've verified/repaired DOOM Eternal through Steam or the Bethesda.net Launcher first.)

	Press L to load mods.
	Press D to delete .resources backups.
	Press N to exit this shell file.\n\n
	"

while read -p "Press key: " inp; do
	case $inp in 
		[lL])
			echo "load mods"
			;;
		[dD])
			DeleteBackups
			exit 1
			;;
		[nN])
			echo "Exiting file."
			exit 1
			;;
		*)
			echo "Invalid input"
	esac
done
