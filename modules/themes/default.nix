{ lib, ... }:
with lib;
{
    imports = [
        ./tokyonight
    ];
    options.modules.theme = with types; {
        active = mkOption {
            type = nullOr str;
            default = null;
            description = "Name of the theme to use";
        };
    };
}

