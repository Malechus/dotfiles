#       __                 
#      /__\ ____   __      
#     /_\| '_ \ \ / /      
#    //__| | | \ V /       
#    \__/|_| |_|\_/        
#                          
#                          
#     /\   /\__ _ _ __ ___ 
#     \ \ / / _` | '__/ __|
#      \ V / (_| | |  \__ \
#       \_/ \__,_|_|  |___/
# 

#XDG Vars
export XDG_CONFIG_HOME="$HOME"/.config
export XDG_DATA_HOME="$HOME"/.local/share
export XDG_CACHE_HOME="$HOME"/.local/cache
export XDG_STATE_HOME="$HOME"/.local/state
export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:=/tmp}"

# ASPNET Vars
export ASPNETCORE_ENVIRONMENT=Development

# zsh Vars
if [[ -z "$ZDOTDIR" ]] then
	export ZDOTDIR="$XDG_CONFIG_HOME"/zsh
fi
HISTFILE="$ZDOTDIR"/.histfile
HISTSIZE=1000
SAVEHIST=1000

# Network Vars
export kicprod=66.228.34.152
export fangprod=104.237.144.235
