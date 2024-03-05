{ config, pkgs, lib, ...}:
with lib.my;
{
    imports = (mapModulesRec' (toString ./.) import);
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
        fzf.enable = true;
        carapace.enable = true;
        navi.enable = true;
        mise.enable = true;
        # direnv.enable = true;
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
