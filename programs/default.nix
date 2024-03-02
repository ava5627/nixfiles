{ config, pkgs, ...}:
{
    imports = [
        ./kitty.nix
        ./firefox.nix
        ./zathura.nix
        ./dunst.nix
    ];
    programs = {
        btop = {
            enable = true;
            settings = {
                color_theme = "dracula";
                theme_background = false;
            };
        };
        lsd.enable = true;
        ripgrep.enable = true;
        zoxide.enable = true;
        bat = {
            enable = true;
            extraPackages = with pkgs.bat-extras; [ batman ];
        };
        feh.enable = true;
        git = {
            enable = true;
            difftastic.enable = true;
            userName = if pkgs.system == "x86_64-linux" then "ava5627" else "ava-harris";
            userEmail = if pkgs.system == "x86_64-linux" then "avasharris1@gmail.com" else "ava-harris@bayer.com";
        };
        gh.enable = true;
        neovim = {
            enable = true;
            defaultEditor = true;
            vimAlias = true;
            vimdiffAlias = true;
            withNodeJs = true;
        };
        mpv = {
            enable = true;
            scripts = [ pkgs.mpvScripts.mpris ];
        };
        obs-studio.enable = true;
    };
    services = {
        copyq.enable = true;
        flameshot = {
            enable = true;
            settings = {
                General = {
                    checkForUpdates = false;
                    contrastOpacity = 153;
                    contrastUiColor = "#4c566a";
                    disabledTrayIcon = true;
                    savePath = "${config.xdg.userDirs.pictures}/Screenshots";
                    savePathFixed = false;
                    showDesktopNotification = false;
                    showHelp = false;
                    showSidePanelButton = true;
                    showStartupLaunchMessage = false;
                    uiColor = "#3384d0";
                };
            };
        };
        playerctld.enable = true;
        kdeconnect = {
            enable = true;
            indicator = true;
        };
    };
}
