source /etc/profile.d/bash_completion.sh

export TERM=xterm-256color
export TERMINFO=/usr/share/terminfo

git_checkout (){
    git_root=$(git rev-parse --show-toplevel)
    git checkout $(git branch -a --list "*"'$*'"*" | tr '*' ' ' | rev | cut -d '/' -f 1 | rev | head -n 1)
    cd "$git_root" || return
    cd $(find $git_root -name "*"$*"*" -type d -prune 2>/dev/null | awk -F'/' '{for(i=1; i<=NF; i++) {if($i ~ /'$*'/){print $0 " " length($i)}}}' | sort -n -k 2 | cut -d ' ' -f 1 | head -n 1) || return
    if [[ $(pwd) == "$HOME" ]]
    then
        cd "$git_root" || return
    fi
}

stot (){
    for f in $1/*
	do 
		if [[ -d $f ]] 
		then 
			fun "$f"
		else 
			echo "fixing $f"
			perl -p -i -e 's/    /\t/g' "$f"
		fi
	done
}
ttos (){
    for f in $1/*
	do 
		if [[ -d $f ]] 
		then 
			fun "$f"
		else 
			echo "fixing $f"
			perl -p -i -e 's/\t/    /g' "$f"
		fi
	done
}

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

docker-build (){
    if [[ $# -gt 0 ]]
    then
        docker build . -t $1
    else
        docker build .
    fi
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

# added by pipx (https://github.com/pipxproject/pipx)
export PATH="$PATH:/home/phillip/.local/bin"

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
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

alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

ble-sabbrev dm='docker container kill $(docker container ps --all -q) || docker rm $(docker ps -aq)'
alias dm='docker container kill $(docker container ps --all -q) || docker rm $(docker ps -aq)'
ble-sabbrev dn='docker image rm $(docker images -aq) --force'
alias dn='docker image rm $(docker images -aq) --force'
ble-sabbrev dfl='docker volume rm `docker volume ls | tail -n +2 | cut -f 2- -d " " | xargs`'
alias dfl='docker volume rm `docker volume ls | tail -n +2 | cut -f 2- -d " " | xargs`'

ble-sabbrev dcu='docker-compose up '
alias dcu='docker-compose up'
ble-sabbrev dcub='docker-compose up --build'
alias dcub='docker-compose up --build'

ble-sabbrev sonarsc='sonar-scanner -Dsonar.login=edf0042d0b8d63db8d84c1691c0c034dfda02aeb'
alias sonarsc='sonar-scanner -Dsonar.login=edf0042d0b8d63db8d84c1691c0c034dfda02aeb'
ble-sabbrev dcheck='dependency-check.sh --scan . --format HTML --format JSON --enableExperimental --out reports/'
alias dcheck='dependency-check.sh --scan . --format HTML --format JSON --enableExperimental --out reports/'

xhost local:docker 2>/dev/null >/dev/null || : # allow docker to send to us
export MICRO_TRUECOLOR=1
shopt -s autocd #enable changing directory by typing folder name

sysinfo (){
    for i in /etc/update-motd.d/*; do if [ "$i" != "/etc/update-motd.d/98-fsck-at-reboot" ]; then $i; fi; done
}
sysinfo

alias sshfs-aws='sshfs ec2-user@ec2-54-152-174-193.compute-1.amazonaws.com:/home/ec2-user/dev ~/dev/ec2 -o IdentityFile=~/.ssh/aws-ec2.pem'
alias ssh-aws='ssh -i "~/.ssh/aws-ec2.pem" ec2-user@ec2-54-152-174-193.compute-1.amazonaws.com'

_ble_contrib_fzf_base=~/.fzf
_ble_contrib_fzf_git_config=key-binding:sabbrev:arpeggio
export PATH="${PATH:+${PATH}:}~/.fzf/bin"

[[ ${BLE_VERSION-} ]] && ble-attach
[[ ${BLE_VERSION-} ]] && ble-import -d contrib/fzf-completion
[[ ${BLE_VERSION-} ]] && ble-import -d contrib/fzf-key-bindings
[[ ${BLE_VERSION-} ]] && ble-import -d contrib/fzf-git
[[ ${BLE_VERSION-} ]] && ble-import contrib/prompt-git

bleopt prompt_rps1='\q{contrib/git-name} \q{contrib/git-branch} \q{contrib/git-path}'
bleopt prompt_rps1_final=" "
bleopt complete_auto_wordbreaks=$' \t\n\\,;/:.'
bleopt history_share=1

ble-face auto_complete='fg=8'

ble-bind -f C-M-u       'capitalize-eword'
ble-bind -f C-M-c       'copy-region-or copy-backward-uword'
ble-bind -f C-y         set-mark
ble-bind -m 'emacs' -c 'C-l' "clear -x"
ble-bind -f up 'history-search-backward immediate-accept'
ble-bind -f down 'history-search-forward immediate-accept'

# some git abbrevs
ble-sabbrev g='git'
alias g='git'
ble-sabbrev gs='git status'
alias gs='git status'
ble-sabbrev ga='git add'
alias ga='git add'
ble-sabbrev gc='git commit'
alias gc='git commit'
ble-sabbrev gl='git pull'
alias gl='git pull'
ble-sabbrev gp='git push -u origin `git symbolic-ref HEAD --short`'
alias gp='git push'
ble-sabbrev gba='git branch -a'
alias gba='git branch -a'
ble-sabbrev grs='git restore'
alias grs='git restore'
ble-sabbrev gco='git checkout'
alias gco='git checkout'
ble-sabbrev gcl='git fetch -p && { git branch --merged master; git branch --merged Development; } | grep -v "^[ *]*master$\|^[ *]*Development$" | xargs git branch -D'
alias gcl='git fetch -p && { git branch --merged master; git branch --merged Development; } | grep -v "^[ *]*master$\|^[ *]*Development$" | xargs git branch -D'
# fzf-git has gf gb gt gh gr

ble-sabbrev ofe='nautilus . &'
alias ofe='nautilus . &'

# some ls abbrevs
alias ll='ls -lisAH'
alias la='ls -A'
alias l='ls -CF'

bleopt complete_auto_history=
# bleopt complete_auto_complete=
bleopt complete_menu_complete=
bleopt complete_menu_filter=

bind 'set completion-ignore-case on'
bind 'set skip-completed-text off'
bind 'set show-all-if-unmodified on'
bind 'set show-all-if-ambiguous on'
bind 'set menu-complete-display-prefix on'
bind 'TAB:menu-complete'
bind 'set colored-completion-prefix on'

bind -x '"\C-l": clear; ls'

bind '"\C-a": "\e[1;3D\C-y\e[1;3C"'

bind '"\e[1;3D": beginning-of-line'
bind '"\e[1;3C": end-of-line'

ble-bind -m 'emacs' -f 'M-S-left' '@marked beginning-of-line'
ble-bind -m 'emacs' -f 'M-S-right' '@marked end-of-line'

ble-bind -m 'emacs' -f 'S-left' '@marked backward-char'
ble-bind -m 'emacs' -f 'S-right' '@marked forward-char'

ble-bind -m 'emacs' -f 'C-z' 'emacs/undo'
ble-bind -m 'emacs' -f 'C-M-z' 'emacs/redo'

ble-bind -m 'emacs' -f 'M-c' 'set-mark'
ble-bind -m 'emacs' -f 'C-c' 'copy-region-or discard-line'

ble-bind -m 'emacs' -f 'M-,' 'kill-backward-cword'
ble-bind -m 'emacs' -f 'M-.' 'kill-forward-cword'

function ble/widget/.copy-range {
  local p0 p1 len
  ble/widget/.process-range-argument "${@:1:2}" || return 1

  # copy
  echo -n "${_ble_edit_str:p0:len}" | xclip -selection "clipboard"
}

export XDG_DATA_HOME="$HOME"/.local/share
export XDG_CONFIG_HOME="$HOME"/.config
export XDG_STATE_HOME="$HOME"/.local/state
export XDG_CACHE_HOME="$HOME"/.cache

export CARGO_HOME="$XDG_DATA_HOME"/cargo
export DOCKER_CONFIG="$XDG_CONFIG_HOME"/docker
export GNUPGHOME="$XDG_DATA_HOME"/gnupg
export NODE_REPL_HISTORY="$XDG_DATA_HOME"/node_repl_history
export _JAVA_OPTIONS=-Djava.util.prefs.userRoot="$XDG_CONFIG_HOME"/java
export WINEPREFIX="$XDG_DATA_HOME"/wine
export ERRFILE="$XDG_CACHE_HOME/X11/xsession-errors"
export RUSTUP_HOME="$XDG_DATA_HOME"/rustup
export NPM_CONFIG_USERCONFIG=$XDG_CONFIG_HOME/npm/npmrc

alias yarn='yarn --use-yarnrc "$XDG_CONFIG_HOME/yarn/config"'
alias wget='wget --hsts-file="$XDG_DATA_HOME/wget-hsts"'

alias ssh-diagon='ssh defender@diagon.defenders.dev -p 6666'
alias sshfs-diagon='sshfs defender@diagon.defenders.dev:cerebro ~/dev/cerebro-diagon -p 6666'

# NNN file browser
export PATH="$PATH:${XDG_CONFIG_HOME:-$HOME/.config}/nnn/plugins"

alias sz='source ~/.bashrc'

# Project setup
function cerebro-frontend {
    cd "$HOME/dev/cerebro/frontend" || return
    echo "
    rm temp
    . ~/.bashrc
    micro src/store/index.ts
    " > temp
    tilix -a session-add-right -e "bash -c 'bash --init-file temp'"

    echo "
    rm temp
    . ~/.bashrc
    cd '..' || return
    make build
    " > temp
    tilix -a session-add-down -e "bash -c 'bash --init-file temp'"

    npm run dev
}
function cerebro-api {
    cd "$HOME/dev/cerebro/api" || return
    go build cmd/main.go

    echo "
    rm temp
    . ~/.bashrc
    micro internal/dbms/seed/seed.go
    " > temp
    tilix -a session-add-right -e "bash -c 'bash --init-file temp'"
    tilix -a session-switch-to-terminal-2

    echo "
    rm temp
    . ~/.bashrc
    until ./main ./api --conn-chk > /dev/null
    do
        sleep 1;
    done
    ./main --debug
    " > temp
    tilix -a session-add-down -e "bash -c 'bash --init-file temp'"
    tilix -a session-switch-to-terminal-1


    echo "
    rm temp
    . ~/.bashrc
    cd '..' || return
    make debug-db
    " > temp
    tilix -a session-add-down -e "bash -c 'bash --init-file temp'"

    until ./main --conn-chk > /dev/null
    do
        sleep 1;
    done
    sudo -u postgres psql -h localhost
}
