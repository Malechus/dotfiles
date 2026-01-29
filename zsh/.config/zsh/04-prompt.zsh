#    __________                               __   
#    \______   \_______  ____   _____ _______/  |_ 
#     |     ___/\_  __ \/  _ \ /     \\____ \   __\
#     |    |     |  | \(  <_> )  Y Y  \  |_> >  |  
#     |____|     |__|   \____/|__|_|  /   __/|__|  
#                                   \/|__|        


# Display time in 24 Hour format on right
RPROMPT="%F{#F6C604}%*%f"

# Display user@host and then PWD (depth of 4) on new line on left
PS1="%F{#F6C604}%B%n@%m%b%f
%F{#069494}%4~%#%f"

# Insert empty line before each prompt, except first prompt
precmd() {
	precmd() {
		echo
	}
}
