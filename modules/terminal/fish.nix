{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.terminal.fish;
in {
  options.modules.terminal.fish = {
    enable = mkBool true "fish";
  };

  config = mkIf cfg.enable {
    home = {
      xdg.configFile."fish/" = {
        source = "${config.dotfiles.config}/fish";
        recursive = true;
      };
      programs.fish = {
        enable = true;
        shellAliases = {
          cla = "clear; exec fish";
        };
        interactiveShellInit =
          /*
          fish
          */
          ''
            set fish_greeting
            function fish_user_key_bindings
              bind \cq kill-whole-line
              bind \cr history-pager
              bind \ew backward-kill-bigword
              bind \cj down-or-search
              bind \ck up-or-search
              bind \er rm_to_rf
            end
            fastfetch
          '';
      };
    };
    environment.shells = with pkgs; [fish];
    users.defaultUserShell = pkgs.fish;
    programs.fish.enable = true;
  };
}
