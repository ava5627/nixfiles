{
  config,
  lib,
  ...
}:
with lib; let
  mkOpt = type: default: mkOption {inherit type default;};
  cfg = config.modules.theme;
in {
  options.modules.theme = with types; {
    active = mkOption {
      type = nullOr str;
      default = null;
      description = "Name of the theme to use";
    };

    colors = {
      background = mkOpt str "#000000";
      foreground = mkOpt str "#ffffff";
      black = mkOpt str "#000000";
      white = mkOpt str "#ffffff";
      gray = mkOpt str "#bbbbbb";
      red = mkOpt str "#ff0000";
      orange = mkOpt str "#ff5f00";
      yellow = mkOpt str "#d7ff00";
      green = mkOpt str "#5fff00";
      purple = mkOpt str "#af87ff";
      cyan = mkOpt str "#5fd7ff";
      pink = mkOpt str "#ff87af";
      blue = mkOpt str "#0000ff";
    };

    rofi = {
      accent = mkOpt str cfg.colors.cyan;
      accent-alt = mkOpt str cfg.colors.pink;
      background = mkOpt str cfg.colors.background;
      background-light = mkOpt str cfg.colors.black;
      text-color = mkOpt str cfg.colors.foreground;
    };
    qtile = {
      background = mkOpt str cfg.colors.background;
      foreground = mkOpt str cfg.colors.white;
      active = mkOpt str cfg.colors.blue;
      inactive = mkOpt str cfg.colors.gray;
      current-group-background = mkOpt str cfg.colors.blue;
      other-screen-group-background = mkOpt str cfg.colors.black;
      active-group-foreground = mkOpt str cfg.colors.cyan;
      powerline-colors = {
        odd = mkOpt str cfg.colors.cyan;
        even = mkOpt str cfg.colors.black;
      };
    };

    dunst = {
      urgency_critical = {
        background = mkOpt str "\"${cfg.colors.background}\"";
        foreground = mkOpt str "\"${cfg.colors.foreground}\"";
        frame_color = mkOpt str "\"${cfg.colors.foreground}\"";
      };
      urgency_normal = {
        background = mkOpt str "\"${cfg.colors.background}\"";
        foreground = mkOpt str "\"${cfg.colors.foreground}\"";
        frame_color = mkOpt str "\"${cfg.colors.foreground}\"";
      };
      urgency_low = {
        background = mkOpt str "\"${cfg.colors.background}\"";
        foreground = mkOpt str "\"${cfg.colors.foreground}\"";
        frame_color = mkOpt str "\"${cfg.colors.foreground}\"";
      };
    };
  };

  config = mkIf (cfg.active != null) {
    home.xdg.configFile."qtile/colors.json".text = builtins.toJSON cfg.qtile;
    home.xdg.configFile."rofi/colors.rasi".text = ''
      /* ${cfg.active} */
      * {
          background: ${cfg.rofi.background};
          background-light: ${cfg.rofi.background-light};
          text-color: ${cfg.rofi.text-color};
          accent: ${cfg.rofi.accent};
          accent-alt: ${cfg.rofi.accent-alt};
      }
    '';
  };
}
