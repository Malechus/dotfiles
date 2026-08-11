#!/bin/sh
# This script configures X to output displays on four connected monitors.
xrandr --output HDMI-0 --mode 1920x1080 --pos 1094x1080 --rotate normal --primary --output DP-0 --mode 1920x1080 --pos 3014x1080 --rotate left --output DP-1 --off --output DP-2 --mode 1920x1080 --pos 1094x0 --rotate normal --output DP-3 --off --output DP-4 --mode 1920x1080 --pos 0x1080 --rotate right --output DP-5 --off
