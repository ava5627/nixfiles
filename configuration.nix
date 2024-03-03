# Edit this configuration file to define what should be installed on
# your system.    Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, inputs, ... }:

{
    imports =
        [
            inputs.home-manager.nixosModules.home-manager
            inputs.nix-gc-env.nixosModules.default
            ./systemd.nix
        ];

    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    nix.gc = {
        automatic = true;
        dates = "weekly";
        delete_generations = "+5";
    };
    nix.optimise = {
        automatic = true;
        dates = [ "weekly" ];
    };

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
    hardware.bluetooth.enable = true;
    services.printing.enable = true;

    # Configure X11
    services.xserver = {
        enable = true;
        xkb = {
            layout = "us";
            variant = "";
        };
        displayManager.sddm = {
            enable = true;
            theme = "${import ./packages/sddm-theme.nix {inherit pkgs; }}";
        };
        windowManager.qtile = {
            enable = true;
            extraPackages = p: with p; [
                xlib
                pillow
            ];
        };
    };
    virtualisation.docker.enable = true;

    services.picom.enable = true;

    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.ava = {
        shell = pkgs.fish;
        isNormalUser = true;
        description = "Ava";
        extraGroups = [ "networkmanager" "wheel" "docker" ];
        packages = [ ];
    };

    services.gnome.gnome-keyring.enable = true;
    security.polkit.enable = true;

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    # List packages installed in system profile. To search, run:
    environment.systemPackages = with pkgs; [
        # system
        home-manager

        # shell programs
        neofetch # system info
        fd # find replacement
        stow # symlink manager
        jq # json processor
        tldr # explain commands
        rofi # application launcher and menu
        xcolor # color picker
        xdotool # keyboard and mouse automation
        xdg-ninja # search for .files in home directory that can be moved

        # applications
        insync # google drive sync
        solaar # logitech device manager
        logiops # logitech device manager
        morgen # calendar
        discord # chat
        openrgb # RGB controller
        blueberry # graphical bluetooth manager
        qalculate-gtk # calculator
        pcmanfm # file manager
        pavucontrol # PulseAudio Volume Control
        gnome.file-roller # archive manager
        libsForQt5.okular # document viewer
        qpwgraph # pipewire graph interface
        geeqie # image viewer
        gimp # image editor
        vlc # media player

        # utilities
        unzip # zip file extractor
        wget # web requests
        xclip # clipboard manager
        curl # web requests
        arandr # screen layout editor
        dua # disk usage analyzer
        ffmpeg # multimedia framework
        file # file type identification
        glow # terminal markdown viewer
        wine # windows compatibility layer


        # development
        rustup
        nodejs
        gnumake
        gcc
        jdk17 # java 17
        jdk8 # java 8

        # qt
        libsForQt5.qt5.qtquickcontrols2 # required for sddm theme
        libsForQt5.qt5.qtgraphicaleffects # required for sddm theme

        # shell scripts
        (pkgs.writeShellScriptBin "powermenu" (builtins.readFile ./bin/rofi/powermenu))
        (pkgs.writeShellScriptBin "edit_configs" (builtins.readFile ./bin/rofi/edit_configs))
    ];
    environment.shells = with pkgs; [ fish ];
    environment.sessionVariables = {
        # Xdg directories
        XDG_CONFIG_HOME = "$HOME/.config";
        XDG_CACHE_HOME = "$HOME/.cache";
        XDG_DATA_HOME = "$HOME/.local/share";
        XDG_STATE_HOME = "$HOME/.local/state";
    };

    environment.variables = {
        # Set the default editor
        EDITOR = "nvim";

        NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc";
        CUDA_CACHE_PATH="$XDG_CACHE_HOME/nv";
        HISTFILE="$XDG_STATE_HOME/bash/history";
        GNUPGHOME="$XDG_DATA_HOME/gnupg";
        SCREENRC="$XDG_CONFIG_HOME/screen/screenrc";
        GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc";
        NUGET_PACKAGES="$XDG_CACHE_HOME/NuGetPackages";
        KERAS_HOME="$XDG_STATE_HOME/keras";
        WINEPREFIX="$XDG_DATA_HOME/wine";
        XINITRC="$XDG_CONFIG_HOME/X11/xinitrc";
        GOPATH="$XDG_CONFIG_HOME/go";
        ANDROID_HOME="$XDG_DATA_HOME/android";
        GRADLE_USER_HOME="$XDG_DATA_HOME/gradle";
        MYSQL_HISTFILE="$XDG_DATA_HOME/mysql_history";
        ZDOTDIR="$HOME/.config/zsh";
        PARALLEL_HOME="$XDG_DATA_HOME/parallel";
        RUSTUP_HOME="$XDG_DATA_HOME/rustup";
        CARGO_HOME="$XDG_DATA_HOME/cargo";
        WGETRC="$XDG_CONFIG_HOME/wgetrc";
        VIRTUAL_ENV_DISABLE_PROMPT="1";
        DOCKER_CONFIG="$XDG_CONFIG_HOME/docker";
        NODE_REPL_HISTORY_FILE="$XDG_DATA_HOME/node_repl_history";
        XCOMPOSECACHE="$XDG_CACHE_HOME/X11/compose";
    };

    environment.etc."logid.cfg".source = ./dotfiles/logid.cfg;

    fonts.packages = with pkgs; [
        noto-fonts
        noto-fonts-cjk
        noto-fonts-emoji
        liberation_ttf
        (nerdfonts.override { fonts = [ "SourceCodePro" "Ubuntu" "UbuntuMono" ]; })
        source-code-pro
    ];

    users.defaultUserShell = pkgs.fish;

    sound.enable = true;
    programs = {
        nm-applet.enable = true;
        fish.enable = true;

        dconf.enable = true;
        steam.enable = true;

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

    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.users.ava = import ./home.nix;
}
