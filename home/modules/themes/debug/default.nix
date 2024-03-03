{ config, lib, ...}:

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
    };
}
