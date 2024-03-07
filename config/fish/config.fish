set fish_greeting                                 # Supresses fish's intro message

set fish_color_host $fish_color_user
set fish_color_cwd magenta #$fish_color_param
set -g fish_prompt_pwd_dir_length 0

if set -q VIRTUAL_ENV && contains $VIRTUAL_ENV/bin $PATH
    set index (contains -i $VIRTUAL_ENV/bin $PATH)
    set -ge PATH[$index]
    set -gxp PATH $VIRTUAL_ENV/bin
end

# If not running interactively, don't continue
if not status --is-interactive
  exit
end

function fish_user_key_bindings
    # fish_vi_key_bindings
    # bind -M insert \cq kill-whole-line
    fish_default_key_bindings
    bind \cq kill-whole-line
end

set __fish_git_prompt_showupstream verbose
set __fish_git_prompt_showcolorhints 1
set __fish_git_prompt_use_informative_chars 1
set __fish_git_prompt_color_upstream red
set __fish_git_prompt_showdirtystate 1
set __fish_git_prompt_char_dirtystate '*'

# Quick aliases

# clear
alias cls='clear'
alias c='clear'
alias cla='clear; exec fish'


# nix
alias nr='sudo nixos-rebuild switch --flake .'
abbr -a nrh 'sudo nixos-rebuild switch --flake .#'

# ls
alias ls='lb'
alias ll='lb -l'
alias la='lb -A'
alias lla='lb -lA'


alias ip='ip --color=auto'

alias q=exit

alias vim='nvim'
alias v='nvim .'

alias qlog='clear && tail -f ~/.local/share/qtile/qtile.log'

alias ranger='ranger --choosedir=/tmp/ranger_dir; set LASTDIR (cat /tmp/ranger_dir); cd $LASTDIR; rm /tmp/ranger_dir'

# python
alias vc='python -m venv .venv'
alias va='source ./.venv/bin/activate.fish'
alias vv='source ./.venv/bin/activate.fish & nvim .'

alias cam='mpv av://v4l2:/dev/video0 --profile=low-latency --untimed'

# Directory cd
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias cb='cd -'

alias man="batman"

alias gs 'git status --short'
alias gss 'git status'
abbr -a ga 'git add'
alias gad 'git add .'
abbr -a gc 'git commit'
abbr -a gca 'git commit --amend'
abbr -a gcm 'git commit -m'
abbr -a gcam 'git commit -am'
alias gp 'git push'
alias gpl 'git pull'

# Startup
neofetch
