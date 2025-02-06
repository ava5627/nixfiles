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
        blue = "#89b4fa";
        gray = "#181825"; # mantle
        cyan = "#89dceb"; # sky
        pink = "#cba6f7";
        red = "#f38ba8";
      };
      qtile = {
        background = cfg.colors.background;
        foreground = cfg.colors.foreground;
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
    };
    catppuccin = {
      accent = "sky";
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
        accent = "sky";
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
