# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh//.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

bindkey -v

autoload -Uz compinit
compinit
zmodload zsh/complist
autoload -U compinit && compinit
autoload -U colors && colors

#completion options
zstyle ':completion:*' menu select

for config (~/.config/zsh/*.zsh) source $config

for config (~/.config/zsh/.*.zsh) source $config

if [[ command -v neofetch >/dev/null 2>&1 ]] then
	neofetch
fi
