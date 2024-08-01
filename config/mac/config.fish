# Variables
export NPM_CONFIG_USERCONFIG=$XDG_CONFIG_HOME/npm/npmrc
export CUDA_CACHE_PATH=$XDG_CACHE_HOME/nv
export HISTFILE=$XDG_STATE_HOME/bash/history
export GNUPGHOME=$XDG_DATA_HOME/gnupg
export SCREENRC=$XDG_CONFIG_HOME/screen/screenrc
export GTK2_RC_FILES=$XDG_CONFIG_HOME/gtk-2.0/gtkrc
export NUGET_PACKAGES=$XDG_CACHE_HOME/NuGetPackages
export KERAS_HOME=$XDG_STATE_HOME/keras
export WINEPREFIX="$XDG_DATA_HOME"/wine
export XINITRC="$XDG_CONFIG_HOME"/X11/xinitrc
export GOPATH="$XDG_CONFIG_HOME"/go
export ANDROID_HOME="$XDG_DATA_HOME"/android
export GRADLE_USER_HOME="$XDG_DATA_HOME"/gradle
export MYSQL_HISTFILE="$XDG_DATA_HOME"/mysql_history
export ZDOTDIR="$HOME"/.config/zsh
export PARALLEL_HOME="$XDG_DATA_HOME"/parallel
export JAVA_HOME="/usr/lib/jvm/default"
export RUSTUP_HOME="$XDG_DATA_HOME"/rustup
export CARGO_HOME="$XDG_DATA_HOME"/cargo
export WGETRC="$XDG_CONFIG_HOME"/wgetrc
export VIRTUAL_ENV_DISABLE_PROMPT=1
export DOCKER_CONFIG="$XDG_CONFIG_HOME"/docker
export NODE_REPL_HISTORY_FILE="$XDG_DATA_HOME"/node_repl_history
export IPYTHONDIR="$XDG_CONFIG_HOME"/ipython

# Abbreviations
abbr --add -- ga 'git add'
abbr --add -- gc 'git commit'
abbr --add -- gca 'git commit --amend -a'
abbr --add -- gcam 'git commit -am'
abbr --add -- gcm 'git commit -m'
abbr --add -- gdh 'git diff HEAD^'
abbr --add -- grc 'gh repo create --public --source=. '

# Aliases
alias .. 'cd ..'
alias ... 'cd ../..'
alias .... 'cd ../../..'
alias c clear
alias cam 'mpv av://v4l2:/dev/video0 --profile=low-latency --untimed --demuxer-lavf-o=video_size=1920x1080'
alias cb 'cd -'
alias cla 'clear; exec fish'
alias gad 'git add .'
alias gd 'git diff'
alias gf 'git push --force-with-lease'
alias gl 'git pull'
alias gp 'git push'
alias gs 'git status -s'
alias gss 'git status'
alias ip 'ip -c'
alias ipa 'ip addr'
alias la 'ls -A'
alias ll 'ls -l'
alias lla 'ls -lA'
alias ls lb
alias man batman
alias pyc 'echo layout python > .envrc && direnv allow'
alias pyi 'test -f pyproject.toml && poetry install || poetry init'
alias qlog 'clear && tail -f ~/.local/share/qtile/qtile.log'
alias v 'nvim .'
alias vimdiff 'nvim -d'

# Program shell integration
direnv hook fish | source
zoxide init fish --cmd cd | source
fzf --fish | source

fastfetch
