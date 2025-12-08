{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop;
in {
  options.modules.desktop = {
    enable = mkBool true "desktop";
    insync.autoStart = mkBool true "Start insync on login";
  };

  config = mkIf cfg.enable {
    services = {
      displayManager.sddm = {
        enable = true;
        theme = mkDefault "${pkgs.my.eucalyptus-drop}";
        package = pkgs.kdePackages.sddm;
        autoNumlock = true;
        extraPackages = with pkgs; [
          qt6.qtsvg
          qt6.qt5compat
        ];
      };
    };
    modules.desktop = {
      dunst.enable = true;
      firefox.enable = true;
      flameshot.enable = true;
      kitty.enable = true;
      zathura.enable = true;
      discord.enable = true;
      rofi.enable = true;
    };

    home = {
      programs.obs-studio.enable = true;
      programs.mpv = {
        enable = true;
        scripts = [pkgs.mpvScripts.mpris];
      };
      home.shellAliases = {
        cam = ''mpv av://v4l2:/dev/video0 --profile=low-latency --untimed --demuxer-lavf-o=video_size=1920x1080'';
      };
      home.pointerCursor = {
        name = "Bibata-Modern-Ice";
        package = pkgs.bibata-cursors;
        dotIcons.enable = false; # creates ~/.icons for backward compatibility reasons, if you have issues set this to true
        size = 0;
      };
    };

    environment.systemPackages = with pkgs; [
      qalculate-gtk # calculator
      arandr # screen layout editor
      insync # google drive sync
      pcmanfm # file manager
      lxmenu-data # adds applications to the open-with menu
      kdePackages.okular # document viewer
      geeqie # image viewer
      gimp3 # image editor
      vlc # media player
      polkit_gnome # polkit authentication agent
      libnotify # notifications
      kdePackages.kdenlive # video editor
      libreoffice # office suite
      file-roller # archive manager

      # shell scripts
      (writers.writeBashBin "edit_configs" (builtins.readFile "${config.dotfiles.bin}/rofi/edit_configs"))
      (writers.writeBashBin "edit_repos" {
        makeWrapperArgs = ["--prefix" "PATH" ":" "${lib.makeBinPath [tokei]}"];
      } (builtins.readFile "${config.dotfiles.bin}/rofi/edit_repos"))
      (writers.writeBashBin "powermenu" {
        makeWrapperArgs = ["--prefix" "PATH" ":" "${lib.makeBinPath [procps]}"];
      } (builtins.readFile "${config.dotfiles.bin}/rofi/powermenu"))
    ];
    programs.appimage.enable = true;
    security.polkit.enable = true;
    systemd.user.services.polkit-gnome-authentication-agent-1 = {
      description = "PolicyKit Authentication Agent";
      wantedBy = ["graphical-session.target"];
      wants = ["graphical-session.target"];
      after = ["graphical-session.target"];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
    modules.autoStart =
      optionals cfg.insync.autoStart ["insync start"];
  };
}
