{ config, lib, pkgs, ...}:

with lib;
let
    cfg = config.modules.theme;
in
{
    config = mkIf (cfg.active == "Tokyo Night") {
        modules.theme = {
            colors = {
                foreground = "#c0caf5";
                background = "#15161e";
                black = "#1a1b26";
                white = "#f8f8f2";
                blue = "#3d59a1";
                gray = "#2f343f";
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
                other-screen-group-background = "#3b4261";
                active-group-foreground = cfg.colors.cyan;
                powerline-colors = {
                    odd = cfg.colors.black;
                    even = cfg.colors.cyan;
                };
            };
            rofi = {
                accent = cfg.colors.cyan;
                accent-alt = cfg.colors.pink;
                background = cfg.colors.background;
                background-light = cfg.colors.black;
                text-color = cfg.colors.foreground;
            };
            # fish = {
            #     selection = "#33467c";
            #     comment = "#565f89";
            #     cyan = "#7dcfff";
            # };
        };
        xdg.configFile = {
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
                foreground = cfg.colors.foreground;
                frame_color = cfg.colors.foreground;
            };
            urgency_normal = {
                background = cfg.colors.black;
                foreground = cfg.colors.cyan;
                frame_color = cfg.colors.blue;
            };
            urgency_critical = {
                background = "#292e42";
                foreground = "#db4b4b";
                frame_color = "#db4b4b";
            };
        };
    };
}
