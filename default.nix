# Edit this configuration file to define what should be installed on
# your system.    Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  pkgs,
  inputs,
  lib,
  config,
  ...
}:
with lib.my; {
  imports =
    [
      inputs.nix-gc-env.nixosModules.default
    ]
    ++ (mapModulesRec' (toString ./modules) import);

  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    use-xdg-base-directories = true;
  };
  nix.gc = {
    automatic = true;
    dates = "weekly";
    delete_generations = "+5"; # keep only the last 5 generations
    persistent = true;
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

  # List packages installed in system profile. To search, run:
  environment.systemPackages = with pkgs; [
    unzip # zip file extractor
    wget # web requests
    curl # web requests
    file # file type identification
    nvd # nix package version diff
    psmisc # process management
    procps # process management
    gnumake # make
    gcc # c compiler
    (writeScriptBin "manage" (builtins.readFile "${config.dotfiles.bin}/manage.py"))
  ];
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    (nerdfonts.override {fonts = ["SourceCodePro" "Ubuntu" "UbuntuMono"];})
    source-code-pro
    # corefonts
  ];

  programs = {
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
