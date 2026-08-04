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

	space)
		echo "pinup" > $currentSettingFile
		echo "Setting walls to pinup at $(date +"%D %T")" >> $currentLogFile
		cd ~/.config/i3/walls
		feh --bg-fill horizontal/phone_pinup.png horizontal/ub_pinup.png vertical/wash_pinup.png vertical/wp_pinup.png --no-fehbg
		notify("pinup")
		;;
	
	base | pinup)
		echo "anime" > $currentSettingFile
		echo "Setting walls to anime at $(date +"%D %T")" >> $currentLogFile
		cd ~/.config/i3/walls
		feh --bg-fill horizontal/flowers-19.jpg horizontal/marin-eat-cat-mac.png vertical/frieren3.png vertical/maomao1.png --no-fehbg
		notify("anime")
		;;
	anime)
		echo "tech" > $currentSettingFile
		echo "Setting walls to tech at $(date +"%D %T")" >> $currentLogFile
		cd ~/.config/i3/walls
		feh --bg-fill horizontal/blueprint.png horizontal/bacta.png vertical/mech1.png vertical/mech2.png --no-fehbg
		notify("tech")
		;;
	tech)
		echo "tech2" > $currentSettingFile
		echo "Setting walls to tech2 at $(date +"%D %T")" >> $currentLogFile
		cd ~/.config/i3/walls
		feh --bg-fill horizontal/old-computer.png horizontal/tux_root.png vertical/mc_hallway.jpg vertical/galaxy.jpg --no-fehbg
		notify("tech2")
		;;
	tech2)
		echo "arch" > $currentSettingFile
		echo "Setting walls to arch at $(date +"%D %T")" >> $currentSetting
		cd ~/.config/i3/walls
		feh --bg-fill horizontal/arch_windows.png horizontal/catp_arch.png vertical/galaxy.jpg vertical/mc_archi.jpg --no-fehbg
		notify("arch")
		;;
	arch)
		echo "shadowheart" > $currentSettingFile
		echo "Setting walls to shadowheart at $(date +"%D %T")" >> $currentLogFile
		cd ~/.config/i3/walls
		feh --bg-fill horizontal/shdwhrt_field.png horizontal/shdwhrt_model.jpg vertical/cosp_shdwhrt_ling.jpg vertical/cosp_shdwhrt_flowers.jpg --no-fehbg
		notify("shadowheart")
		;;
	shadowheart)
		echo "karlach" > $currentSettingFile
		echo "Setting walls to karlach at $(date +"%D %T")" >> $currentLogFile
		cd ~/.config/i3/walls
		feh --bg-fill horizontal/karlach_screen.png horizontal/karlach_coat.jpg vertical/karlach-portrait.jpg vertical/karlach_strap.jpg --no-fehbg
		notify("karlach")
		;;
	karlach)
		echo "space" > $currentSettingFile
		echo "Setting walls to space at $(date +"%D %T")" >> $currentLogFile
		cd ~/.config/i3/walls
		feh --bg-fill horizontal/mc-moon.jpg horizontal/mc_moon_crater.jpg vertical/galaxy.jpg vertical/galaxy.jpg --no-fehbg
		notify("space")
		;;
esac

function notify(){
	notify-send -u "low" -t 2000 "Setting wallpaper to $1"
}
