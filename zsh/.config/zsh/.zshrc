#                       .__                   
#        ________  _____|  |_________   ____  
#        \___   / /  ___/  |  \_  __ \_/ ___\ 
#         /    /  \___ \|   Y  \  | \/\  \___ 
#     /\ /_____ \/____  >___|  /__|    \___  >
#     \/       \/     \/     \/            \/ 

for config (~/.config/zsh/*.zsh) source $config

source ~/.config/zsh/.zprofile

# opencode
export PATH=/home/malechus/.opencode/bin:$PATH

export NVM_DIR="$HOME/.nvm"
 [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
 [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
