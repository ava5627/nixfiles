{ config, lib, pkgs, ... }:
with lib;
{
    config = mkIf config.services.xserver.enable {
        services.xserver = {
            displayManager.sddm = {
                enable = true;
                theme = "${pkgs.my.sugar-candy}";
            };
            xkb = {
                layout = "us";
                variant = "";
                options = "caps:ctrl_modifier";
            };
        };

        environment.systemPackages = with pkgs; [
            xdotool # keyboard and mouse automation
            xclip # clipboard manager
            blueberry # graphical bluetooth manager
            qalculate-gtk # calculator

            libsForQt5.qt5.qtquickcontrols2 # required for sddm theme
            libsForQt5.qt5.qtgraphicaleffects # required for sddm theme
            # shell scripts
            (writeShellScriptBin "powermenu"    (builtins.readFile "${config.dotfiles.bin}/rofi/powermenu"))
            (writeShellScriptBin "edit_configs" (builtins.readFile "${config.dotfiles.bin}/rofi/edit_configs"))
        ];
    };
}