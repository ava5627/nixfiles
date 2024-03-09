{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  iniFormat = pkgs.formats.ini {};
  cfg = config.modules.desktop.flameshot;
in {
  options.modules.desktop.flameshot.enable = mkEnableOption "Flameshot";
  config = mkIf cfg.enable {
    environment.systemPackages = [pkgs.flameshot];

    home.xdg.configFile = {
      "flameshot/flameshot.ini".source = iniFormat.generate "flameshot.ini" {
        General = {
          checkForUpdates = false;
          contrastOpacity = 153;
          contrastUiColor = "#4c566a";
          disabledTrayIcon = true;
          savePath = "/home/${config.user.name}/Pictures/Screenshots";
          savePathFixed = false;
          showDesktopNotification = false;
          showHelp = false;
          showSidePanelButton = true;
          showStartupLaunchMessage = false;
          uiColor = "#3384d0";
        };
      };
    };
  };
}
