#!/usr/bin/env fish

set -l CFG_DIR $HOME/.config

set -l directories (
    "fish"
    "kitty"
    "ipython/profile_default"
    "git"
)

for directory in $directories
    mkdir -p $CFG_DIR/$directory
end


# create symlinks
# config/mac/config.fish -> $HOME/.config/fish/config.fish
# config/fish/completions -> $HOME/.config/fish/completions
# config/fish/functions -> $HOME/.config/fish/functions
# config/mac/kitty.conf -> $HOME/.config/kitty/kitty.conf
# modules/themes/tokyonight/config/fish.fish -> $HOME/.config/fish/conf.d/tokyonight.fish
# config/fastfetch -> $HOME/.config/fastfetch
# config/ipython/profile_default/ipython_config.py -> $HOME/.config/ipython/profile_default/ipython_config.py
# config/mac/gitconfig -> $HOME/.config/git/config
# config/mac/gitignore -> $HOME/.config/git/ignore
# config/firefox/userChrome.css -> $HOME/.config/userChrome.css

# make sure in the right directory (config directory exists and contains mac directory)
if test -d ./config/mac
    echo "Error: run in nixfiles directory"
    exit 1
end

ln -s $PWD/config/mac/config.fish $CFG_DIR/config.fish
ln -s $PWD/config/fish/completions $CFG_DIR/fish/completions
ln -s $PWD/config/fish/functions $CFG_DIR/fish/functions
ln -s $PWD/modules/themes/tokyonight/config/fish.fish $CFG_DIR/fish/conf.d/tokyonight.fish

ln -s $PWD/config/mac/kitty.conf $CFG_DIR/kitty/kitty.conf

ln -s $PWD/config/fastfetch $CFG_DIR/fastfetch

ln -s $PWD/config/ipython/profile_default/ipython_config.py $CFG_DIR/ipython/profile_default/ipython_config.py

ln -s $PWD/config/mac/gitconfig $CFG_DIR/git/config
ln -s $PWD/config/mac/gitignore $CFG_DIR/git/ignore

ln -s $PWD/config/firefox/userChrome.css $CFG_DIR/userChrome.css
