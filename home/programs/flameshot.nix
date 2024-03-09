{
  config,
  pkgs,
  ...
}: let
  iniFormat = pkgs.formats.ini {};
in {
  home.packages = [pkgs.flameshot];

  xdg.configFile = {
    "flameshot/flameshot.ini".source = iniFormat.generate "flameshot.ini" {
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
}
