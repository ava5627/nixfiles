{
  config,
  lib,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.services.audiobookshelf;
in {
  options.modules.services.audiobookshelf.enable = mkBool false "Audio book library";
  config = mkIf cfg.enable {
    services.audiobookshelf = {
      enable = true;
      host = "192.168.1.175";
    };
  };
}
