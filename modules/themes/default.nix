{
  pkgs,
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
      gray = mkOpt str "#888888";
      red = mkOpt str "#ff0000";
      orange = mkOpt str "#ff7f00";
      yellow = mkOpt str "#ffff00";
      green = mkOpt str "#00ff00";
      purple = mkOpt str "#5f00ff";
      cyan = mkOpt str "#5fd7ff";
      pink = mkOpt str "#ff07af";
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
      powerline-colors = mkOpt (listOf (attrsOf str)) [
        {
          fg = cfg.colors.black;
          bg = cfg.colors.blue;
        }
        {
          fg = cfg.colors.blue;
          bg = cfg.colors.black;
        }
      ];
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
    environment.variables = {
      COLORSCHEME = cfg.active;
    };
    home = {
      xdg.configFile = let
        qtile_enabled = config.modules.desktop.qtile.enable;
        rofi_enabled = config.modules.desktop.rofi.enable;
      in {
        "qtile/colors.json" = {
          enable = qtile_enabled;
          text = builtins.toJSON cfg.qtile;
        };
        "rofi/colors.rasi" = {
          enable = rofi_enabled;
          text = ''
            /* ${cfg.active} Theme */
            /* Generated by Nix do not edit manually */
            * {
              background: ${cfg.rofi.background};
              background-light: ${cfg.rofi.background-light};
              text-color: ${cfg.rofi.text-color};
              accent: ${cfg.rofi.accent};
              accent-alt: ${cfg.rofi.accent-alt};
            }
          '';
        };
        "dunst/dunstrc.d/00-tokyo-night.conf" = let
          iniFormat = pkgs.formats.ini {};
        in {
          enable = config.modules.desktop.dunst.enable;
          source = iniFormat.generate "tokyonight-dunst" {
            urgency_low = cfg.dunst.urgency_low;
            urgency_normal = cfg.dunst.urgency_normal;
            urgency_critical = cfg.dunst.urgency_critical;
          };
        };
      };
      programs.rofi.theme = let
        inherit (config.home.lib.formats.rasi) mkLiteral;
      in {
        "*" = {
          accent = mkLiteral cfg.rofi.accent;
          accent-alt = mkLiteral cfg.rofi.accent-alt;
          background = mkLiteral cfg.rofi.background;
          background-light = mkLiteral cfg.rofi.background-light;
          text-color = mkLiteral cfg.rofi.text-color;

          background-color = mkLiteral cfg.rofi.background-light;
          border-color = mkLiteral cfg.rofi.accent;
        };
        listview = {
          background-color = mkLiteral cfg.rofi.background;
        };
      };
    };
  };
}
