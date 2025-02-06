{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.theme;
in {
  config = mkIf (cfg.active == "Tokyo Night") {
    modules.theme = {
      colors = {
        foreground = "#c0caf5";
        background = "#15161e";
        black = "#1a1b26";
        white = "#f8f8f2";
        blue = "#3d59a1";
        gray = "#292e42";
        cyan = "#7aa2f7";
        purple = "#9d7cd8";
        red = "#f7768e";
        orange = "#ff9e64";
        yellow = "#e0af68";
        green = "#9ece6a";
        pink = "#bb9af7";
      };
      qtile = {
        background = cfg.colors.background;
        foreground = cfg.colors.white;
        active = cfg.colors.blue;
        inactive = cfg.colors.gray;
        current-group-background = cfg.colors.blue;
        other-screen-group-background = cfg.colors.gray;
        active-group-foreground = cfg.colors.cyan;
        powerline-colors = [
          {
            fg = cfg.colors.black;
            bg = cfg.colors.cyan;
          }
          {
            fg = cfg.colors.cyan;
            bg = cfg.colors.black;
          }
        ];
      };
      rofi = {
        accent = cfg.colors.cyan;
        accent-alt = cfg.colors.pink;
        background = cfg.colors.background;
        background-light = cfg.colors.black;
        text-color = cfg.colors.foreground;
      };
      # source: https://github.com/folke/tokyonight.nvim/blob/main/extras/dunst/tokyonight_night.dunstrc
      dunst = {
        urgency_low = {
          background = "\"#16161e\"";
          foreground = "\"${cfg.colors.foreground}\"";
          frame_color = "\"${cfg.colors.foreground}\"";
        };
        urgency_normal = {
          background = "\"${cfg.colors.black}\"";
          foreground = "\"${cfg.colors.cyan}\"";
          frame_color = "\"${cfg.colors.blue}\"";
        };
        urgency_critical = {
          background = "\"#292e42\"";
          foreground = "\"#f7768e\"";
          frame_color = "\"#f7768e\"";
        };
      };
    };
    qt = {
      style = "kvantum";
      platformTheme = "qt5ct";
    };
    home = {
      gtk = {
        theme = {
          package = pkgs.tokyonight-gtk-theme;
          name = "Tokyonight-Dark";
        };
        iconTheme = {
          package = pkgs.my.tokyo-night-theme;
          name = "Tokyonight";
        };
      };
      xdg.configFile = {
        "fish/conf.d/colors.fish" = {
          enable = config.modules.terminal.fish.enable;
          source = ./config/fish.fish;
        };
        "Kvantum/KvArcTokyoNight" = {
          enable = config.modules.desktop.qt.enable;
          source = "${pkgs.my.tokyo-night-theme}/share/Kvantum/KvArcTokyoNight";
        };
        "Kvantum/kvantum.kvconfig" = {
          enable = config.modules.desktop.qt.enable;
          text = "[General]\ntheme=KvArcTokyoNight\n";
        };
        "BetterDiscord/themes/midnight.theme.css" = {
          enable = config.modules.desktop.discord.enable;
          source = ./config/midnight.theme.css;
        };
      };
      programs.kitty = {
        themeFile = "tokyo_night_night";
        settings = {
          color16 = "#1a1b26";
        };
      };
      # source: https://github.com/folke/tokyonight.nvim/blob/main/extras/fzf/tokyonight_night.sh
      programs.fzf.defaultOptions = [
        "--color=fg:-1,fg+:#c0caf5,bg:-1,bg+:#292e42"
        "--color=hl:#3d59a1,hl+:#7aa2f7,info:#9ece6a,marker:#f7768e"
        "--color=prompt:#d7005f,spinner:#af5fff,pointer:#af5fff,header:#bb9af7"
        "--color=border:#262626,label:#aeaeae,query:#c0caf5"
        "--layout=reverse"
      ];
      # source: https://github.com/folke/tokyonight.nvim/blob/main/extras/zathura/tokyonight_night.zathurarc
      programs.zathura.options = {
        "completion-bg" = "#16161e";
        "completion-fg" = "#c0caf5";
        "completion-group-bg" = "#3b4261";
        "completion-group-fg" = "#c0caf5";
        "completion-highlight-bg" = "#33467c";
        "completion-highlight-fg" = "#c0caf5";
        "default-fg" = "#c0caf5";
        "default-bg" = "#1a1b26";
        "inputbar-fg" = "#c0caf5";
        "inputbar-bg" = "#1a1b26";
        "notification-fg" = "#a0c980";
        "notification-bg" = "#1a1b26";
        "notification-error-fg" = "#ec7279";
        "notification-error-bg" = "#1a1b26";
        "notification-warning-fg" = "#deb974";
        "notification-warning-bg" = "#1a1b26";
        "tabbar-fg" = "#c0caf5";
        "tabbar-bg" = "#16161e";
        "tabbar-focus-fg" = "#1a1b26";
        "tabbar-focus-bg" = "#d38aea";
        "statusbar-fg" = "#c0caf5";
        "statusbar-bg" = "#1a1b26";
        "highlight-color" = "#3d59a1";
        "highlight-active-color" = "#ff9e64";
        "recolor-darkcolor" = "#c0caf5";
        "recolor-lightcolor" = "#1a1b26";
        "render-loading-bg" = "#deb974";
        "render-loading-fg" = "#1a1b26";
        "index-fg" = "#c0caf5";
        "index-bg" = "#1a1b26";
        "index-active-fg" = "#1a1b26";
        "index-active-bg" = "#7aa2f7";
      };
      programs.btop.settings.color_theme = "dracula";
    };
  };
}
