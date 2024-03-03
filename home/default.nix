{ config, pkgs, lib, ... }:

with lib.my;
{
    imports = [
        ./programs
    ] ++ (mapModulesRec' (toString ./modules) import);
    modules.theme.active = "Tokyo Night";

    home.username = "ava";
    home.homeDirectory = "/home/ava";
    gtk = {
        enable = true;
        gtk2 = {
            configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
        };
        font = {
            package = pkgs.noto-fonts;
            name = "Noto Sans";
            size = 11;
        };
    };

    home.pointerCursor = {
        name = "Bibata-Modern-Ice";
        package = pkgs.bibata-cursors;
        size = 0;
    };

    qt.enable = true;

    xdg = {
        enable = true;
        userDirs = {
            enable = true;
            createDirectories = true;
        };
    };
    xdg.configFile = {
        "neofetch/".source = ../dotfiles/neofetch;
        "ranger".source = ../dotfiles/ranger;
        "ideavim/ideavimrc".source = ../dotfiles/ideavimrc;
        "ipython/profile_default/ipython_config.py".source = ../dotfiles/ipython_config.py;
        "copyq/" = {
            source = ../dotfiles/copyq;
            recursive = true;
        };
        "fish/" = {
            source = ../dotfiles/fish;
            recursive = true;
        };
        "nvim/" = {
            source = ../dotfiles/nvim;
            recursive = true;
        };
        "qtile/" = {
            source = ../dotfiles/qtile;
            recursive = true;
        };
        "rofi" = {
            source = ../dotfiles/rofi;
            recursive = true;
        };
    };

    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager release
    # introduces backwards incompatible changes.
    #
    # You should not change this value, even if you update Home Manager. If you do
    # want to update the value, then make sure to first check the Home Manager
    # release notes.
    home.stateVersion = "23.11"; # Please read the comment before changing.

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;
}
