{ config, pkgs, dotfiles, ... }:
{
    imports = [
        ./programs
    ];

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
        "neofetch/".source = "${dotfiles.config}/neofetch";
        "ranger".source = "${dotfiles.config}/ranger";
        "ideavim/ideavimrc".source = "${dotfiles.config}/ideavimrc";
        "ipython/profile_default/ipython_config.py".source = "${dotfiles.config}/ipython_config.py";
        "nvim/" = {
            source = "${dotfiles.config}/nvim";
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
