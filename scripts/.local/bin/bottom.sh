#!/bin/sh
#This script sets X to display output on three monitors with the expectation that another computer will be on the bottom display.
if [ "$(hostnamectl --static)" = "polyphemus" ]; then
	xrandr --output HDMI-0 --off --output DP-0 --mode 1920x1080 --pos 3014x0 --rotate left --output DP-1 --off --output DP-2 --primary --mode 1920x1080 --pos 1080x840 --rotate normal --output DP-3 --off --output DP-4 --mode 1920x1080 --pos 0x0 --rotate right --output DP-5 --off
fi
