{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; {
  config = mkIf config.services.xserver.enable {
    services.xserver.xkb = {
      layout = "us";
      variant = "";
      options = "caps:ctrl_modifier"; # make caps lock an additional ctrl
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
