{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.modules.theme;
in {
  imports = [
    inputs.catppuccin.nixosModules.catppuccin
  ];
  config = mkIf (cfg.active == "Catppuccin") {
    modules.theme = {
      colors = {
        foreground = "#cdd6f4"; # text
        background = "#1e1e2e"; # base
        black = "#11111b"; # crust
        blue = "#3d59a1";
        gray = "#585b70";
        cyan = "#89dceb"; # sky
        pink = "#cba6f7"; # mauve
        red = "#f38ba8";
      };
      qtile = {
        background = cfg.colors.background;
        foreground = cfg.colors.foreground;
        active = cfg.colors.blue;
        inactive = cfg.colors.gray;
        current-group-background = cfg.colors.blue;
        other-screen-group-background = "#181825";
        active-group-foreground = cfg.colors.foreground;
        powerline-colors = [
          {
            bg = "#f38ba8";
            fg = "#181825";
          }
          {
            bg = "#fab387";
            fg = "#181825";
          }
          {
            bg = "#f9e2af";
            fg = "#181825";
          }
          {
            bg = "#a6e3a1";
            fg = "#181825";
          }
          {
            bg = "#74c7ec";
            fg = "#181825";
          }
          {
            bg = "#45475a";
            fg = "#cdd6f4";
          }
          {
            bg = "#313244";
            fg = "#cdd6f4";
          }
        ];
      };
      rofi = {
        accent = "#89b4fa";
        accent-alt = cfg.colors.pink;
        background = cfg.colors.black;
        background-light = cfg.colors.background;
        text-color = cfg.colors.foreground;
      };
      # source: https://github.com/folke/tokyonight.nvim/blob/main/extras/dunst/tokyonight_night.dunstrc
    };
    catppuccin = {
      accent = "mauve";
      flavor = "mocha";
      sddm.enable = true;
      sddm.background = "${config.dotfiles.config}/camp_fire.jpg";
    };
    services.displayManager.sddm.package = pkgs.kdePackages.sddm;
    home = {
      imports = [
        inputs.catppuccin.homeManagerModules.catppuccin
      ];
      qt.style.name = "kvantum";
      qt.platformTheme.name = "kvantum";
      catppuccin = {
        accent = "mauve";
        flavor = "mocha";
        bat.enable = true;
        btop.enable = true;
        delta.enable = true;
        dunst.enable = true;
        fish.enable = true;
        fzf.enable = true;
        gtk.enable = true;
        gtk.icon.enable = true;
        kitty.enable = true;
        kvantum.enable = true;
        lsd.enable = true;
        mpv.enable = true;
        zathura.enable = true;
      };
      xdg.configFile = {
        "BetterDiscord/themes/midnight.theme.css" = {
          enable = config.modules.desktop.discord.enable;
          source = ./config/midnight.theme.css;
        };
      };
    };
  };
}
