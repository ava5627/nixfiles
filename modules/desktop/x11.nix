{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; {
  config = mkIf config.services.xserver.enable {
    services.xserver = {
      xkb = {
        layout = "us";
        variant = "";
        options = "caps:ctrl_modifier"; # make caps lock an additional ctrl
      };
      serverFlagsSection = ''
        Option "BlankTime" "0"
        Option "StandbyTime" "0"
        Option "SuspendTime" "0"
        Option "OffTime" "0"
      '';
    };
    home = {
      xsession = {
        enable = true;
        scriptPath = ".local/share/xsession";
        profilePath = ".local/share/xprofile";
      };
    };
    environment.systemPackages = with pkgs; [
      xdotool # keyboard and mouse automation
      xclip # clipboard manager
      xorg.xkill # kill a window
      xdotool # keyboard and mouse automation
      xorg.xev # event viewer
    ];
  };
}
