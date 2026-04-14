#       _   _ _                     
#      /_\ | (_) __ _ ___  ___  ___ 
#     //_\\| | |/ _` / __|/ _ \/ __|
#    /  _  \ | | (_| \__ \  __/\__ \
#    \_/ \_/_|_|\__,_|___/\___||___/
#                                   


alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrp --color=auto'

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

alias vim='nvim'

alias paths='echo -e ${PATH//:/\\n}'

alias please='sudo !!'

alias copilot='copilot --allow-tool=shell(ls:*) --allow-tool=shell(cat:*) --allow-tool=shell(echo:*) --allow-tool=shell(git fetch) --allow-tool=shell(git checkout) --allow-tool=shell(grep:*) --allow-tool=shell(find:*) --allow-tool=shell(tail:*) --allow-tool=shell(head:*) --allow-tool=url(https://docs.github.com)'
