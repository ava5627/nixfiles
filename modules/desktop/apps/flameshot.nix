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
    # modules.autoStart = [
    #   "flameshot"
    # ];
    systemd.user.services.flameshot = {
      description = "Flameshot screenshot tool";
      requires = ["tray.target"];
      after = ["graphical-session-pre.target" "tray.target"];
      partOf = ["graphical-session.target"];
      wantedBy = ["graphical-session.target"];
      serviceConfig = {
        Environment = "PATH=${config.home.home.profileDirectory}/bin";
        ExecStart = "${pkgs.flameshot}/bin/flameshot";
        Restart = "on-abort";

        # Sandboxing.
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateUsers = true;
        RestrictNamespaces = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = "@system-service";
      };
    };

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
