{ ... }:
{
    imports = [
        ./hardware-configuration.nix
        ../default.nix
    ];

    boot.loader.systemd-boot.enable = true;
}
