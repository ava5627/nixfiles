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

# programs
zoxide init fish --cmd cd | source

# Quick aliases

# clear
alias cls='clear'
alias c='clear'
alias cla='clear; exec fish'

# pacman
alias pacs='sudo pacman -Syu'
alias pacq='pacman -Q'
alias pacr='sudo pacman -Rns'
alias pacss='pacman -Ss'
alias pacsi='pacman -Si'
alias pacqs='pacman -Qs'
alias pacqi='pacman -Qi'
alias pacar='sudo pacman -Rns (pacman -Qtdq)'

# yay
alias ys='yay -Sua'
alias yss='yay -Ss'

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

# Dotfiles
alias gconfig='git --git-dir=$HOME/dotfiles/.git --work-tree=$HOME/dotfiles'

alias man="batman"

abbr -a gs 'git status'
abbr -a gsb 'git status -sb'
abbr -a ga 'git add'
abbr -a gc 'git commit'
abbr -a gcm 'git commit -m'

# Startup
neofetch
