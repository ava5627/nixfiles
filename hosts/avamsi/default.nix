{ ... }:
{
    imports = [
        ./hardware-configuration.nix
    ];
    modules.theme.active = "Tokyo Night";
    modules.desktop.qtile.enable = true;

    networking.hostName = "avamsi";
    boot.loader.systemd-boot.enable = true;
}
