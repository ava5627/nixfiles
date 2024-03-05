{ config, lib, pkgs, ... }:
with lib;
with lib.my;
let
    cfg = config.modules.desktop.qtile;
    configDir = config.dotfiles.config;
in
{
    options.modules.desktop.qtile = {
        enable = mkBool true "qtile";
    };

    config = mkIf cfg.enable {
        services = {
            xserver = {
                enable = true;
                windowManager.qtile = {
                    enable = true;
                    extraPackages = p: with p; [
                        xlib
                        pillow
                    ];
                };
            };
            picom.enable = true;
        };

        home.xdg.configFile."qtile" = {
            source = "${configDir}/qtile";
            recursive = true;
        };

        environment.systemPackages = with pkgs; [
            xcolor # color picker
        ];
    };
}
