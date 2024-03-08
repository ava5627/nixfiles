{ ... }:
{
    imports = [
        # ./hardware-configuration.nix
    ];
    modules.theme.active = "Tokyo Night";
    modules.hardware.nvidia.enable = true;
}
