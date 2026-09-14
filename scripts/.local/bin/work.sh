#!/bin/bash
# this helper script sets X to display output on the main computer to three displays, with the bottom display reserved for another (work) computer. It then sets wallpapers fot those three monitors

bottom.sh 2>&1
sh ~/.config/i3/walls/desktop-3m-cm.sh 2>&1
sh ~/.config/polybar/launch.sh & 2>&1
