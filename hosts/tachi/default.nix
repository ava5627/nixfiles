{...}: {
  imports = [
    ./hardware-configuration.nix
  ];
  modules.theme.active = "Tokyo Night";
  services.xserver.libinput = {
    enable = true;
    touchpad.naturalScrolling = true;
  };
}
