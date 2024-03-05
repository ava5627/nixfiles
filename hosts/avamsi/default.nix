{ ... }:
{
    imports = [
        ./hardware-configuration.nix
    ];
    modules.theme.active = "Tokyo Night";
    boot.loader.systemd-boot.enable = true;
}
