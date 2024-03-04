{ ... }:
{
    imports = [
        ./hardware-configuration.nix
    ];

    networking.hostName = "avamsi";
    boot.loader.systemd-boot.enable = true;
}
