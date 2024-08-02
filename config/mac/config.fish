set fish_greeting                                 # Supresses fish's intro message

export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share
export XDG_STATE_HOME=$HOME/.local/state

export EDITOR=nvim
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export MANROFFOPT="-c"

# clean home dir
export ZDOTDIR="$HOME"/.config/zsh
export DOCKER_CONFIG="$XDG_CONFIG_HOME"/docker
export IPYTHONDIR="$XDG_CONFIG_HOME"/ipython


# If not running interactively, don't continue
if not status --is-interactive
  exit
end

# when a neovim terminal is opened fish re-adds `fish_user_paths` to the PATH, making the VIRTUAL_ENV no longer the first element
# since `/opt/homebrew/bin` is in the `fish_user_paths` and is added to the PATH after the VIRTUAL_ENV
# it means that while the prompt says the VIRTUAL_ENV is active, in actuality homebrew python is being used
# this block of code ensures that the VIRTUAL_ENV is always the first element in the PATH
# also direnv activates the environment but doesn't change the prompt, so disable the prompt and add it manually in the prompt function
export VIRTUAL_ENV_DISABLE_PROMPT=1
if set -q VIRTUAL_ENV && contains $VIRTUAL_ENV/bin $PATH
    set index (contains -i $VIRTUAL_ENV/bin $PATH)
    set -ge PATH[$index]
    set -gxp PATH $VIRTUAL_ENV/bin
end

# programs
zoxide init fish --cmd cd | source
direnv hook fish | source
fzf --fish | source

# Abbreviations
abbr --add -- ga 'git add'
abbr --add -- gc 'git commit'
abbr --add -- gca 'git commit --amend --no-edit'
abbr --add -- gcam 'git commit -am'
abbr --add -- gcm 'git commit -m'
abbr --add -- gdh 'git diff HEAD^'
abbr --add -- grc 'gh repo create --public --source=.'

alias .. 'cd ..'
alias ... 'cd ../..'
alias .... 'cd ../../..'
alias c 'clear'
alias cb 'cd -'
alias cla 'clear; exec fish'
alias gad 'git add .'
alias gd 'git diff'
alias gf 'git push --force-with-lease'
alias gl 'git pull'
alias gp 'git push'
alias gs 'git status -s'
alias gss 'git status'
alias ip 'ip --color=auto'
alias ipa 'ip addr'
alias ll 'lb -l'
alias la 'lb -A'
alias lla 'lb -lA'
alias ls 'lb'
alias man batman
alias pyc 'echo layout python > .envrc && direnv allow'
alias pyi 'test -f pyproject.toml && poetry install || poetry init'
alias v 'nvim .'
alias vim 'nvim'
alias q exit
alias qlog 'clear && tail -f ~/.local/share/qtile/qtile.log'

# Startup
fastfetch
