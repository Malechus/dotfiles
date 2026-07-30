#!/bin/sh
if [ "$(hostnamectl --static)" = "polyphemus" ]; then
	xrandr --output HDMI-0 --off --output DP-0 --mode 1920x1080 --pos 3014x0 --rotate left --output DP-1 --off --output DP-2 --primary --mode 1920x1080 --pos 1094x0 --rotate normal --output DP-3 --off --output DP-4 --mode 1920x1080 --pos 0x0 --rotate right --output DP-5 --off
fi
