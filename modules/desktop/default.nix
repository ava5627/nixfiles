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
    # morgen.autoStart = mkBool true "Start morgen on login";
    insync.autoStart = mkBool true "Start insync on login";
  };

  config = mkIf cfg.enable {
    services = {
      displayManager.sddm = {
        enable = true;
        theme = mkDefault "${pkgs.my.sugar-candy}";
        # package = pkgs.kdePackages.sddm;
        autoNumlock = true;
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
        size = 0;
      };
    };

    environment.systemPackages = with pkgs; [
      qalculate-gtk # calculator
      arandr # screen layout editor
      insync # google drive sync
      # morgen # calendar
      pcmanfm # file manager
      lxde.lxmenu-data # adds applications to the menu
      libsForQt5.okular # document viewer
      geeqie # image viewer
      gimp3 # image editor
      vlc # media player
      polkit_gnome # polkit authentication agent
      libnotify # notifications
      libsForQt5.kdenlive # video editor
      libreoffice # office suite

      libsForQt5.qt5.qtquickcontrols2 # required for sddm theme
      libsForQt5.qt5.qtgraphicaleffects # required for sddm theme

      # (pkgs.catppuccin-sddm.override {
      #   flavor = "mocha";
      #   background = "${config.dotfiles.config}/camp_fire.jpg";
      #   loginBackground = true;
      # })
      # shell scripts
      (writeShellScriptBin "powermenu" (builtins.readFile "${config.dotfiles.bin}/rofi/powermenu"))
      (writeShellScriptBin "edit_configs" (builtins.readFile "${config.dotfiles.bin}/rofi/edit_configs"))
    ];
    programs.file-roller.enable = true;
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
      # optionals cfg.morgen.autoStart ["morgen --hidden"] ++
      optionals cfg.insync.autoStart ["insync start"];
  };
}
