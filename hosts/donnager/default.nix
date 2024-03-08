{ ... }:
{
    imports = [
        ./hardware-configuration.nix
    ];
    modules.theme.active = "Tokyo Night";
    modules.hardware.nvidia.enable = true;
    hardware.nvidia.forceFullCompositionPipeline = true;
    boot.loader.systemd-boot.enable = true;

    services.xserver.xrandrHeads = [
        "DP-2"
        { output = "DP-4"; primary = true; }
        "DP-0"
    ];

}
