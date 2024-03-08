{ config, lib, pkgs, ... }:
with lib;
with lib.my;
let cfg = config.modules.desktop.qtile;
in
{
    options.modules.desktop.qtile = {
        enable = mkBool true "qtile";
        configUrl = mkOpt types.str "https://github.com/ava5627/qtile-config";
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

        environment.systemPackages = with pkgs; [
            xcolor # color picker
        ];
        system.userActivationScripts = {
            qtile.text = ''
                if [ ! -d $XDG_CONFIG_HOME/qtile/.git ]; then
                    mkdir -p $XDG_CONFIG_HOME/qtile
                    rm $XDG_CONFIG_HOME/colors.json || true
                    ${pkgs.git}/bin/git clone ${cfg.configUrl} $XDG_CONFIG_HOME/qtile
                fi
            '';
        };
    };
}
