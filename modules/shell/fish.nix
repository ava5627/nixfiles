{ config, lib, pkgs, ... }:
with lib;
with lib.my;
let cfg = config.modules.shell.fish;
in
{
    options.modules.shell.fish = {
        enable = mkBool true "fish";
    };

    config = mkIf cfg.enable {
        home = {
            xdg.configFile."fish/" = {
                source = "${config.dotfiles.config}/fish";
                recursive = true;
            };
        };
        environment.shells = with pkgs; [ fish ];
        users.defaultUserShell = pkgs.fish;
        programs.fish.enable = true;
    };
}
