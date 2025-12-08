# Edit this configuration file to define what should be installed on
# your system.    Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  pkgs,
  lib,
  ...
}:
with lib.my; {
  imports = mapModulesRec' ./modules import;

  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    use-xdg-base-directories = true;
  };
  nix.optimise = {
    automatic = true;
    dates = ["weekly"];
  };

  nixpkgs.overlays = [
    (final: prev: {
      my = mapModules ./packages (p: pkgs.callPackage p {});
    })
  ]; # make my packages accessible via pkgs.my

  # Bootloader.
  boot.loader.efi.canTouchEfiVariables = true;

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  virtualisation.docker.enable = true;
  virtualisation.docker.extraPackages = with pkgs; [
    docker-compose
  ];

  services.gnome.gnome-keyring.enable = true;
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    nvd # nix package version diff
    nix-tree # nix dependency tree
    my.manage
  ];
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    liberation_ttf
    nerd-fonts.ubuntu-mono
    nerd-fonts.ubuntu
    nerd-fonts.sauce-code-pro
    source-code-pro
    # corefonts
  ];

  programs = {
    nh = {
      enable = true;
      flake = "/home/ava/nixfiles"; # path to default flake when no flake is specified
      clean = {
        enable = true;
        dates = "weekly"; # clean up old generations weekly
        extraArgs = "--keep 5"; # keep only the last 5 generations
      };
    }; # nix cli helper
    dconf.enable = true;

    nix-ld.enable = true;
    nix-ld.libraries = [
      # add missing dynamic libraries for unpackaged programs here
    ];
  };

  services.gvfs.enable = true; # auto mount usb

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
