#    __________                               __   
#    \______   \_______  ____   _____ _______/  |_ 
#     |     ___/\_  __ \/  _ \ /     \\____ \   __\
#     |    |     |  | \(  <_> )  Y Y  \  |_> >  |  
#     |____|     |__|   \____/|__|_|  /   __/|__|  
#                                   \/|__|        


# Display time in 24 Hour format on right
RPROMPT="%F{#F6C604}%*%f"

autoload -Uz vcs_info
setopt prompt_subst

# Only show Git metadata when the current directory is inside a Git worktree.
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' formats ' %F{#c6a0f6}[%b]%f'

# Display user@host and then PWD (depth of 4) on new line on left
PS1='%F{#F6C604}%B%n@%m%b%f
%F{#069494}%4~%f${vcs_info_msg_0_} %F{#069494}%#%f '

typeset -g _prompt_initialized=0

# Insert empty line before each prompt, except first prompt
precmd() {
	# Refresh the branch segment before each prompt draw.
	vcs_info

	if (( _prompt_initialized )); then
		echo
	else
		_prompt_initialized=1
	fi
}
