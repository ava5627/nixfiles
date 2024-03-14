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
      xdg.configFile."fish/completions/" = {
        source = "${config.dotfiles.config}/fish/completions";
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
            set -g fish_prompt_pwd_dir_length 0
            set __fish_git_prompt_showupstream informative
            set __fish_git_prompt_char_upstream_prefix " "
            set __fish_git_prompt_showcolorhints 1
            set __fish_git_prompt_use_informative_chars 1
            set __fish_git_prompt_color_upstream red
            set __fish_git_prompt_showdirtystate 1
            set __fish_git_prompt_char_dirtystate '*'
            function fish_user_key_bindings
              bind \cq kill-whole-line
              bind \cr history-pager
              bind \ew backward-kill-bigword
              bind \cj down-or-search
              bind \ck up-or-search
            end
            neofetch
          '';
        functions = {
          fish_prompt = {
            body = builtins.readFile "${config.dotfiles.config}/fish/functions/fish_prompt.fish";
            description = "Custom fish prompt";
          };
          line_one = {
            body =
              /*
              fish
              */
              ''
                set_color $color_cwd --bold
                echo -n (prompt_pwd)
                set_color normal
                echo -n (fish_git_prompt)
              '';
          };
          fish_right_prompt = {
            body = builtins.readFile "${config.dotfiles.config}/fish/functions/fish_right_prompt.fish";
            description = "Custom fish right prompt";
          };
        };
      };
    };
    environment.shells = with pkgs; [fish];
    users.defaultUserShell = pkgs.fish;
    programs.fish.enable = true;
  };
}
