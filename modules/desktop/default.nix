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
    morgen.autoStart = mkBool true "Start morgen on login";
    insync.autoStart = mkBool true "Start insync on login";
  };

  config = mkIf config.services.xserver.enable {
    services.xserver = {
      displayManager.sddm = {
        enable = true;
        theme = "${pkgs.my.sugar-candy}";
      };
      xkb = {
        layout = "us";
        variant = "";
        options = "caps:ctrl_modifier"; # make caps lock an additional ctrl
      };
    };
    modules.desktop = {
      dunst.enable = true;
      firefox.enable = true;
      flameshot.enable = true;
      kitty.enable = true;
      zathura.enable = true;
      rofi.enable = true;
      discord = {
        enable = true;
        plugins = [];
        themes = [
          "https://raw.githubusercontent.com/ava5627/nixfiles/main/modules/themes/tokyonight/config/midnight.theme.css"
        ];
      };
    };

    home = {
      xsession.enable = true;
      programs.obs-studio.enable = true;
      programs.mpv = {
        enable = true;
        scripts = [pkgs.mpvScripts.mpris];
      };
      home.shellAliases = {
        cam = ''mpv av://v4l2:/dev/video0 --profile=low-latency --untimed --demuxer-lavf-o=video_size=1920x1080'';
      };
      services.kdeconnect = {
        enable = true;
        indicator = true;
      };
      xdg.configFile = {
        "copyq/" = {
          source = "${config.dotfiles.config}/copyq";
          recursive = true;
        };
      };
      home.pointerCursor = {
        name = "Bibata-Modern-Ice";
        package = pkgs.bibata-cursors;
        size = 0;
      };
    };

    environment.systemPackages = with pkgs; [
      xdotool # keyboard and mouse automation
      xclip # clipboard manager
      xorg.xkill # kill a window
      xdotool # keyboard and mouse automation
      qalculate-gtk # calculator
      arandr # screen layout editor
      copyq # clipboard manager
      insync # google drive sync
      morgen # calendar
      pcmanfm # file manager
      lxde.lxmenu-data # adds applications to the menu
      shared-mime-info # mime types
      libsForQt5.okular # document viewer
      geeqie # image viewer
      gimp # image editor
      krita # image editor
      vlc # media player
      polkit_gnome # polkit authentication agent
      libnotify # notifications

      libsForQt5.qt5.qtquickcontrols2 # required for sddm theme
      libsForQt5.qt5.qtgraphicaleffects # required for sddm theme
      # shell scripts
      (writeShellScriptBin "powermenu" (builtins.readFile "${config.dotfiles.bin}/rofi/powermenu"))
      (writeShellScriptBin "edit_configs" (builtins.readFile "${config.dotfiles.bin}/rofi/edit_configs"))
    ];
    programs.file-roller.enable = true;
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
      [
        "copyq"
        "systemctl restart --user kdeconnect-indicator"
      ]
      ++ optionals cfg.morgen.autoStart ["morgen --hidden"]
      ++ optionals cfg.insync.autoStart ["insync start"];
  };
}
