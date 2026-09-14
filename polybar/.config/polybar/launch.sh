#!/bin/sh

# First, terminate any running bars
killall -q polybar

# Next, launch bars
polybar --list-monitors | while IFS= read -r m; do
	monitor_name=${m%%:*}
	if printf '%s\n' "$m" | grep -q 'primary'; then
		MONITOR="$monitor_name" polybar --reload primary &
	else
		MONITOR="$monitor_name" polybar --reload secondary &
	fi
done
