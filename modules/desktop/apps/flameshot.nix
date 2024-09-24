{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.desktop.flameshot;
in {
  options.modules.desktop.flameshot.enable = mkEnableOption "Flameshot";
  config = mkIf cfg.enable {
    home.services.flameshot = {
      enable = true;
      settings = {
        General = {
          contrastOpacity = 153;
          contrastUiColor = "#15161e";
          disabledTrayIcon = true;
          savePath = "/home/${config.user.name}/Pictures/Screenshots";
          savePathFixed = false;
          showDesktopNotification = false;
          showHelp = false;
          showSidePanelButton = true;
          showStartupLaunchMessage = false;
          uiColor = "#7aa2f7";
        };
      };
    };
  };
}
