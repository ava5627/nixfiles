{
  config,
  lib,
  inputs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    inputs.nixos-hardware.nixosModules.msi-gs60
  ];

  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "nvme" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelParams = ["acpi_osi=!" "acpi_osi=\"Windows 2009\""]; # make airplane mode key work
  boot.kernelModules = ["kvm-intel"];
  boot.extraModulePackages = [];
  boot.loader.systemd-boot.enable = true;

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/e882cd2f-9b1b-46b8-a23e-cbd920963f27";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/6BDC-3FF9";
    fsType = "vfat";
  };

  swapDevices = [];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.docker0.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp61s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  modules.hardware = {
    nvidia.enable = true;
  };

  hardware.nvidia = {
    open = false; # 1070 is not supported by open drivers
    prime = { # enable NVIDIA Optimus required for any graphics output
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
      sync.enable = true;
    };
  };
  services.libinput = {
    enable = true;
    touchpad.naturalScrolling = true; # reverse scrolling direction
  };
}
