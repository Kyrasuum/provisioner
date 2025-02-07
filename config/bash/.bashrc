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

################################################################################
# Helper functions
################################################################################
docker-start (){
    if [[ $# -gt 0 ]]
    then
        docker run -itd $2 --rm -e DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -v /var/run/docker.sock:/var/run/docker.sock --device=/dev/dri:/dev/dri $1 bash
    fi
}

docker-join (){
    if [[ $# -gt 0 ]]
    then
        docker exec -it $2 -e DISPLAY $1 bash
    fi
}

docker-x11 (){
    docker run -it --rm -e DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -v /var/run/docker.sock:/var/run/docker.sock --device=/dev/dri:/dev/dri $1 bash
}

git-https-to-shh (){
    REPO_URL=$(git remote -v | grep -m1 '^origin' | sed -Ene's#.*(https://[^[:space:]]*).*#\1#p')
    if [ -z "$REPO_URL" ]; then
      echo "-- ERROR:  Could not identify Repo url."
      echo "   It is possible this repo is already using SSH instead of HTTPS."
      exit
    fi

    USER=$(echo "$REPO_URL" | sed -Ene's#https://github.com/([^/]*)/(.*).git#\1#p')
    if [ -z "$USER" ]; then
      echo "-- ERROR:  Could not identify User."
      exit
    fi

    REPO=$(echo "$REPO_URL" | sed -Ene's#https://github.com/([^/]*)/(.*).git#\2#p')
    if [ -z "$REPO" ]; then
      echo "-- ERROR:  Could not identify Repo."
      exit
    fi

    NEW_URL="git@github.com:$USER/$REPO.git"
    echo "Changing repo url from "
    echo "  '$REPO_URL'"
    echo "      to "
    echo "  '$NEW_URL'"
    echo ""

    CHANGE_CMD="git remote set-url origin $NEW_URL"
    $CHANGE_CMD

    echo "Success"
}

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

