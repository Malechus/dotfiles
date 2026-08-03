#!/bin/bash
# This script toggles the screen layout displayed between any of a number of preconfigured settings. 

if [ -z "$XDG_CACHE_HOME" ]; then
	XDG_CACHE_HOME="$HOME/.cache"
fi

#First, let's setup some simple logging.
currentLogFile="$XDG_CACHE_HOME/screens.log"
if [ ! -e "$currentLogFile" ]; then
	echo "Starting log file...." > $currentLogFile
fi

echo "Screen Switcher invoked at $(date +"%D %T")" >> $currentLogFile

# Next, we need to establish a memory of what the last screenpaper config was
currentSettingFile="$XDG_CACHE_HOME/screenSetting"

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

	work)
		echo "personal" > $currentSettingFile
		echo "Setting screens to work at $(date +"%D %T")" >> $currentLogFile
		sh work.sh
		;;
	
	base | personal)
		echo "work" > $currentSettingFile
		echo "Setting screens to personal at $(date +"%D %T")" >> $currentLogFile
		sh personal.sh
		;;
esac

