#!/usr/bin/env fish
if test -e $XDG_CONFIG_HOME/git/config
    cp $XDG_CONFIG_HOME/git/config config/mac/gitconfig
    # replace "/nix/store/*/<program>" with "<program>"
    sed -E 's|/nix/store/[^\s]+/([^/]+)|\1|g' config/mac/gitconfig > config/mac/gitconfig.tmp
    mv config/mac/gitconfig.tmp config/mac/gitconfig
end

if test -e $XDG_CONFIG_HOME/git/ignore
    cp $XDG_CONFIG_HOME/git/ignore config/mac/gitignore
end
