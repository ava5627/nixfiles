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
      excludePackages = with pkgs; [
        xterm
      ];
    };
    home = {
      xsession = {
        enable = true;
        scriptPath = ".local/share/xsession";
        profilePath = ".local/share/xprofile";
      };
    };
    environment.systemPackages = with pkgs; [
      xclip # clipboard manager
      xorg.xkill # kill a window
      xdotool # keyboard and mouse automation
      xorg.xev # event viewer
    ];
    services.libinput = {
      touchpad.naturalScrolling = true; # reverse scrolling direction
    };
  };
}
