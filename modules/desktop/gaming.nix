{ config, lib, ... }:
with lib;
with lib.my;
let cfg = config.modules.desktop.gaming;
in
{
    options.modules.desktop.gaming.enable = mkEnableOption "gaming";
    config = mkIf cfg.enable {
        programs.steam.enable = true;
        # put lutris here eventually
    };
}
