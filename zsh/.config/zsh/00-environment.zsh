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

# zsh Vars
if [[ -z "$ZDOTDIR" ]] then
	export ZDOTDIR="$XDG_CONFIG_HOME"/zsh
fi
HISTFILE="$ZDOTDIR"/.histfile
HISTSIZE=1000
SAVEHIST=1000
