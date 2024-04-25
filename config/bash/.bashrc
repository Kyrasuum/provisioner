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

git-commit-gum (){
	TYPE=$(gum choose "fix" "feat" "docs" "style" "refactor" "test" "chore" "revert")
	SCOPE=$(gum input --placeholder "scope")

	# Since the scope is optional, wrap it in parentheses if it has a value.
	test -n "$SCOPE" && SCOPE="($SCOPE)"

	# Pre-populate the input with the type(scope): so that the user may change it
	SUMMARY=$(gum input --value "$TYPE$SCOPE: " --placeholder "Summary of this change")
	DESCRIPTION=$(gum write --placeholder "Details of this change (CTRL+D to finish)")

	# Commit these changes
	gum confirm "Commit changes?" && git commit -m "$SUMMARY" -m "$DESCRIPTION" $@
}

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/phil/.config/.fzf/shell/completion.bash" 2> /dev/null


# Setup fzf
# ---------
if [[ ! "$PATH" == */home/phil/.config/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/home/phil/.config/.fzf/bin"
fi

# Key bindings
# ------------
source "/home/phil/.config/.fzf/shell/key-bindings.bash"

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


_ble_contrib_fzf_base=~/.fzf
_ble_contrib_fzf_git_config=key-binding:sabbrev:arpeggio
export PATH="${PATH:+${PATH}:}~/.fzf/bin"

if [[ ${BLE_VERSION-} ]]; then
	ble-attach
	ble-import -d contrib/fzf-completion
	ble-import -d contrib/fzf-key-bindings
	ble-import -d contrib/fzf-git
	ble-import contrib/prompt-git

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
	ble-sabbrev gs='git status'
	ble-sabbrev ga='git add'
	ble-sabbrev gcm='git commit -m'
	ble-sabbrev gc='git commit'
	ble-sabbrev gl='git pull'
	ble-sabbrev gm='git merge --no-ff'
	ble-sabbrev gp='git push -u origin `git symbolic-ref HEAD --short`'
	ble-sabbrev gba='git branch -a'
	ble-sabbrev grs='git restore'
	ble-sabbrev gco='git checkout'
	ble-sabbrev gcl='git fetch -p && { git branch --merged master; git branch --merged dev; } | grep -v "^[ *]*master$\|^[ *]*dev$" | xargs git branch -D'

	ble-sabbrev ofe='nautilus . &'

	ble-sabbrev dm='docker container kill $(docker container ps --all -q) || docker rm $(docker ps -aq)'
	ble-sabbrev dn='docker image rm $(docker images -aq) --force'
	ble-sabbrev dfl='docker volume rm `docker volume ls | tail -n +2 | cut -f 2- -d " " | xargs`'
	ble-sabbrev dcu='docker-compose up '
	ble-sabbrev dcub='docker-compose up --build'

	bleopt complete_auto_history=
	# bleopt complete_auto_complete=
	bleopt complete_menu_complete=
	bleopt complete_menu_filter=

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
fi

alias dm='docker container kill $(docker container ps --all -q) || docker rm $(docker ps -aq)'
alias dn='docker image rm $(docker images -aq) --force'
alias dfl='docker volume rm `docker volume ls | tail -n +2 | cut -f 2- -d " " | xargs`'

alias dcu='docker-compose up'
alias dcub='docker-compose up --build'

# alias sonarsc='sonar-scanner -Dsonar.login='
# alias dcheck='dependency-check.sh --scan . --format HTML --format JSON --enableExperimental --out reports/'

# fzf-git has gf gb gt gh gr
alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gl='git pull'
alias gm='git merge --no-ff'
alias gp='git push'
alias gba='git branch -a'
alias grs='git restore'
alias gco='git checkout'
alias gcl='git fetch -p && { git branch --merged master; git branch --merged dev; } | grep -v "^[ *]*master$\|^[ *]*dev$" | xargs git branch -D'
alias ofe='nautilus . &'

# some ls abbrevs
alias ll='ls -lisAH'
alias la='ls -A'
alias l='ls -CF'

shopt -s globstar

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

# NNN file browser
export PATH="$PATH:${XDG_CONFIG_HOME:-$HOME/.config}/nnn/plugins"

alias sz='source ~/.bashrc'

export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
. "/home/phil/.local/share/cargo/env"

# kdesrc-build #################################################################

## Add kdesrc-build to PATH
export PATH="/home/phil/kde/src/kdesrc-build:$PATH"

## Autocomplete for kdesrc-run
function _comp_kdesrc_run
{
  local cur
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"

  # Complete only the first argument
  if [[ $COMP_CWORD != 1 ]]; then
    return 0
  fi

  # Retrieve build modules through kdesrc-run
  # If the exit status indicates failure, set the wordlist empty to avoid
  # unrelated messages.
  local modules
  if ! modules=$(kdesrc-run --list-installed);
  then
      modules=""
  fi

  # Return completions that match the current word
  COMPREPLY=( $(compgen -W "${modules}" -- "$cur") )

  return 0
}

## Register autocomplete function
complete -o nospace -F _comp_kdesrc_run kdesrc-run
################################################################################
