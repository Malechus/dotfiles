#       ___ _             _           
#      / _ \ |_   _  __ _(_)_ __  ___ 
#     / /_)/ | | | |/ _` | | '_ \/ __|
#    / ___/| | |_| | (_| | | | | \__ \
#    \/    |_|\__,_|\__, |_|_| |_|___/
#                   |___/            


# Plugins
source "$ZDOTDIR/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh"
source "$ZDOTDIR/plugins/F-Sy-H/F-Sy-H.plugin.zsh"
source "$ZDOTDIR/plugins/zsh-history-substring-search/zsh-history-substring-search.plugin.zsh"

# Config for substring search
zmodload zsh/terminfo
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down
bindkey '^[[A' history-substring-search-up
bindkey '^[0A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^[0B' history-substring-search-down

