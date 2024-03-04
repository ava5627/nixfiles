{ ... }:
{
    imports = [
        ./hardware-configuration.nix
        ../default.nix
    ];

    networking.hostName = "avamsi";
    boot.loader.systemd-boot.enable = true;
}
