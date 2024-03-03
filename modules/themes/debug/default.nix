{ config, lib, pkgs, ...}:

with lib;
let
    cfg = config.modules.theme;
in
{
    config = mkIf (cfg.active == "debug") {
        modules.theme.qtile = {
            background = cfg.colors.black;
            foreground = cfg.colors.white;
            active = cfg.colors.orange;
            inactive = cfg.colors.green;
            current-group-background = cfg.colors.yellow;
            other-screen-group-background = cfg.colors.pink;
            active-group-foreground = cfg.colors.cyan;
            powerline-colors = {
                even = cfg.colors.red;
                odd = cfg.colors.blue;
            };
        };
        xdg.configFile = {
            "rofi/colors.rasi".source = ./config/rofi.rasi;
            # "qtile/themes/colors.json".source = ./config/qtile.json;
            "fish/conf.d/colors.fish".source = ./config/fish.fish;
        };
        gtk = {
            theme = {
                package = pkgs.tokyonight-gtk-theme-variants.themes.dark-bl;
                name = "Tokyonight-Dark-BL";
            };
            iconTheme = {
                package = pkgs.callPackage ../../../packages/tokyo-icons.nix {};
                name = "Tokyonight-Ava";
            };
        };
        programs.kitty = {
            theme = "Tokyo Night";
            settings = {
                color16 = "#1a1b26";
            };
        };
        services.dunst.settings = {
            global = {
				frame_color = "#8EC07C";
            };
            urgency_low = {
                background = "#16161e";
                foreground = "#c0caf5";
                frame_color = "#c0caf5";
            };
            urgency_normal = {
                background = "#1a1b26";
                frame_color = "#3d59a1";
                foreground = "#7aa2f7";
            };
            urgency_critical = {
                background = "#292e42";
                foreground = "#db4b4b";
                frame_color = "#db4b4b";
            };
        };
    };
}
