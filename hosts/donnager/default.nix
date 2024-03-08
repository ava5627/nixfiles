{ ... }:
{
    imports = [
        ./hardware-configuration.nix
    ];
    modules.theme.active = "Tokyo Night";
    modules.hardware.nvidia.enable = true;
    boot.loader.systemd-boot.enable = true;

    services.xserver.displayManager.sddm.setupScript = ''
        xrandr --output DP-2 --left-of DP-4 --output DP-4 --primary --output DP-0 --right-of DP-4
    '';
}
