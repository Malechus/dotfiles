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

case $currentSetting in 

	four)
		echo "pinup" > $currentSettingFile
		echo "Setting walls to four at $(date +"%D %T")" >> $currentLogFile
		cd ~/.config/i3/walls
		feh --bg-fill horizontal/phone_pinup.png horizontal/ub_pinup.png vertical/wash_pinup.png vertical/wp_pinup.png --no-fehbg
		;;
	
	base | pinup)
		echo "four" > $currentSettingFile
		echo "Setting walls to pinup at $(date +"%D %T")" >> $currentLogFile
		cd ~/.config/i3/walls
		feh --bg-fill horizontal/flowers-19.jpg horizontal/marin-eat-cat-mac.png vertical/frieren3.png vertical/maomao1.png --no-fehbg
		;;
esac

