# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh//.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt notify
unsetopt beep
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/malechus/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall


# Promp setup
#function git_branch() {
#	git rev-parse --abbrev-ref HEAD 2>/dev/null
#}

#PS1="%F{#F6C604}%B%n@%m%b%f %F{#448ee4}%D %T%f %F{#069494}%1~%f:"

#RPROMPT="%F{#F6C604}$(git_branch)%f"

# load addtl modules
zmodload zsh/complist
autoload -U compinit && compinit
autoload -U colors && colors

#completion options
zstyle ':completion:*' menu select

# Load aliases
[ -f "$ZDOTDIR/aliasrc" ] && source "$ZDOTDIR/aliasrc"

# Load additional options
[ -f "$ZDOTDIR/optionrc" ] && source "$ZDOTDIR/optionrc"

# set env vars
export kicprod=66.228.34.152
export fangprod=104.237.144.235

#Add theme
source $ZDOTDIR/plugins/powerlevel10k/powerlevel10k.zsh-theme

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

# To customize prompt, run `p10k configure` or edit ~/.config/zsh//.p10k.zsh.
[[ ! -f ~/.config/zsh//.p10k.zsh ]] || source ~/.config/zsh//.p10k.zsh

# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh
