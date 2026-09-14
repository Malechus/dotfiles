#!/bin/bash
# This script toggles the wallpapers displayed between any of a number of preconfigured settings. 

if [ -z "$XDG_CACHE_HOME" ]; then
	XDG_CACHE_HOME="$HOME/.cache"
fi

#First, let's setup some simple logging.
currentLogFile="$XDG_CACHE_HOME/walls.log"
if [ ! -e "$currentLogFile" ]; then
	echo "Starting log file...." > $currentLogFile
fi

echo "Wall Switcher invoked at $(date +"%D %T")" >> $currentLogFile

# Next, we need to establish a memory of what the last wallpaper config was
currentSettingFile="$XDG_CACHE_HOME/wallSetting"

if [ -e "$currentSettingFile" ]; then
	currentSetting=$(<$currentSettingFile)
	echo "Currently, the setting is $currentSetting" >> $currentLogFile
else
	echo "base" > $currentSettingFile
	echo "No current setting found. The file has been created and will be written to going forward."
	echo "Created storage file at $(date +"%D %T")" >> $currentLogFile
	currentSetting="base"
fi

# Now, we'll add a function to send a notification to the desktop when the wallpaper is changed.
 function notify () {
	notify-send -t 2000 -p "Wallpaper Change" "Setting wallpaper to $1" -i "$1"
}

# And finally, we'll trigger the change, moving through the list based on where we already are.
case $currentSetting in 

	space)
		echo "pinup" > $currentSettingFile
		echo "Setting walls to pinup at $(date +"%D %T")" >> $currentLogFile
		cd ~/.local/share/wallpapers
	feh --bg-fill horizontal/044.png vertical/076.png horizontal/033.png vertical/078.png --no-fehbg
		notify "pinup"
		;;
	
	base | pinup)
		echo "anime" > $currentSettingFile
		echo "Setting walls to anime at $(date +"%D %T")" >> $currentLogFile
		cd ~/.local/share/wallpapers
	feh --bg-fill horizontal/024.png vertical/051.png horizontal/018.jpg vertical/061.png --no-fehbg
		notify "anime"
		;;
	anime)
		echo "tech" > $currentSettingFile
		echo "Setting walls to tech at $(date +"%D %T")" >> $currentLogFile
		cd ~/.local/share/wallpapers
	feh --bg-fill horizontal/004.png vertical/068.png horizontal/007.png vertical/069.png --no-fehbg
		notify "tech"
		;;
	tech)
		echo "tech2" > $currentSettingFile
		echo "Setting walls to tech2 at $(date +"%D %T")" >> $currentLogFile
		cd ~/.local/share/wallpapers
	feh --bg-fill horizontal/043.png vertical/066.jpg horizontal/032.png vertical/054.jpg --no-fehbg
		notify "tech2"
		;;
	tech2)
		echo "arch" > $currentSettingFile
		echo "Setting walls to arch at $(date +"%D %T")" >> $currentLogFile
		cd ~/.local/share/wallpapers
	feh --bg-fill horizontal/011.png vertical/054.jpg horizontal/003.png vertical/063.jpg --no-fehbg
		notify "arch"
		;;
	arch)
		echo "shadowheart" > $currentSettingFile
		echo "Setting walls to shadowheart at $(date +"%D %T")" >> $currentLogFile
		cd ~/.local/share/wallpapers
	feh --bg-fill horizontal/036.jpg vertical/048.jpg horizontal/035.png vertical/047.jpg --no-fehbg
		notify "shadowheart"
		;;
	shadowheart)
		echo "karlach" > $currentSettingFile
		echo "Setting walls to karlach at $(date +"%D %T")" >> $currentLogFile
		cd ~/.local/share/wallpapers
	feh --bg-fill horizontal/021.jpg vertical/057.jpg horizontal/022.png vertical/060.jpg --no-fehbg
		notify "karlach"
		;;
	karlach)
		echo "space" > $currentSettingFile
		echo "Setting walls to space at $(date +"%D %T")" >> $currentLogFile
		cd ~/.local/share/wallpapers
	feh --bg-fill horizontal/028.jpg vertical/054.jpg horizontal/026.jpg vertical/054.jpg --no-fehbg
		notify "space"
		;;
esac
