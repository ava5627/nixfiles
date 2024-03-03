{ config, lib, pkgs, ... }:
with lib;
let cfg = config.modules.harware.nvidia;
in {
    options.modules.harware.nvidia = {
        enable = mkEnableOption "nvidia";
    };

    config = mkIf cfg.enable {
        hardware.opengl = {
            enable = true;
            driSupport = true;
            driSupport32Bit = true;
        };
        services.xserver.videoDrivers = [ "nvidia" ];
        environment.systemPackages = with pkgs; [
            (writeShellScriptBin "nvidia-settings" ''
                #!${stdenv.shell}
                mkdir -p "$XDG_CONFIG_HOME/nvidia"
                exec ${config.boot.kernelPackages.nvidia_x11.settings}/bin/nvidia-settings --config="$XDG_CONFIG_HOME/nvidia/settings"
            '')
        ];
    };
}
