export TERM=xterm-256color
export TERMINFO=/usr/share/terminfo

shopt -s globstar

# set PATH so it includes user's private bin if it exists
if [ -d "$XDG_HOME/bin" ] ; then
    PATH="$XDG_HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$XDG_BIN_HOME" ] ; then
    PATH="$XDG_BIN_HOME:$PATH"
fi

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# load nvm if installed
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_Completion" ] && \. "$NVM_DIR/bash_completion"

################################################################################
# Helper functions
################################################################################
# Key bindings
# ------------
source $XDG_CONFIG_HOME/.fzf/shell/key-bindings.bash
source /etc/profile.d/bash_completion.sh

alias dm='docker container kill $(docker container ps --all -q) || docker rm $(docker ps -aq)'
alias dn='docker image rm $(docker images -aq) --force'
alias dfl='docker volume rm `docker volume ls | tail -n +2 | cut -f 2- -d " " | xargs`'

# fzf-git has gf gb gt gh gr
alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gl='git pull'
alias gm='git merge --no-ff'
alias gp='git push'
alias gb='git branch'
alias gpf='git push --force'
alias gpo='git push -u origin `git symbolic-ref HEAD --short`'
alias gbd='git branch -D'
alias gba='git branch -a'
alias grs='git restore'
alias gco='git checkout'
alias gcl='git fetch -p && { git branch --merged master; git branch --merged dev; } | grep -v "^[ *]*master$\|^[ *]*dev$" | xargs git branch -D'

# some ls abbrevs
alias ll='ls -lisAH'
alias la='ls -A'
alias l='ls -CF'

