{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.services.audiobookshelf;
in {
  options.modules.services.audiobookshelf.enable = mkBool true "Audio book library";
  config = mkIf cfg.enable {
    services.audiobookshelf = {
      enable = true;
      openFirewall = true;
      host = "192.168.1.175";
    };
  };
}
