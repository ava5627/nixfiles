# Edit this configuration file to define what should be installed on
# your system.    Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  pkgs,
  inputs,
  lib,
  ...
}:
with lib.my; {
  imports =
    [
      inputs.home-manager.nixosModules.home-manager
      inputs.nix-gc-env.nixosModules.default
    ]
    ++ (mapModulesRec' (toString ./modules) import);

  nix.settings.experimental-features = ["nix-command" "flakes"];
  nix.settings.use-xdg-base-directories = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    delete_generations = "+5";
  };
  nix.optimise = {
    automatic = true;
    dates = ["weekly"];
  };
  nixpkgs.overlays = [
    (final: prev: {
      my = mapModules ./packages (p: pkgs.callPackage p {});
    })
  ];

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

  # Enable networking
  networking.networkmanager.enable = true;
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  services.avahi.enable = true;
  services.printing.enable = true;

  virtualisation.docker.enable = true;
  virtualisation.docker.extraPackages = with pkgs; [
    docker-compose
  ];

  services.gnome.gnome-keyring.enable = true;
  security.polkit.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  environment.systemPackages = with pkgs; [
    # shell programs
    neofetch # system info
    fd # find replacement
    stow # symlink manager
    jq # json processor
    tlrc # explain commands
    xdg-ninja # search for .files in home directory that can be moved
    dua # disk usage analyzer
    cached-nix-shell # nix shell caching

    # utilities
    unzip # zip file extractor
    wget # web requests
    curl # web requests
    ffmpeg # multimedia framework
    file # file type identification
    glow # terminal markdown viewer
    wine # windows compatibility layer
    nvd # nix package version diff
    playerctl # media player control

    # development
    rustup
    nodejs
    gnumake
    gcc
    jdk17 # java 17
    jdk8 # java 8
    alejandra # nix formatter
    python3Packages.ipython # python repl
    poetry # python package manager
  ];
  environment.variables = {
    MANPAGER = "sh -c 'col -bx | bat -l man -p'";
    MANROFFOPT = "-c";
    PAGER = "bat";
  };
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    (nerdfonts.override {fonts = ["SourceCodePro" "Ubuntu" "UbuntuMono"];})
    source-code-pro
  ];

  sound.enable = true;
  programs = {
    nm-applet.enable = true;

    dconf.enable = true;

    nix-ld.enable = true;
    nix-ld.libraries = [
      # add missing dynamic libraries for unpackaged programs here
    ];
  };

  # List services that you want to enable:
  services.pipewire = {
    enable = true;
    wireplumber.enable = true;
    pulse.enable = true;
    alsa.enable = true;
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.gvfs.enable = true;
  services.hardware.openrgb.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
