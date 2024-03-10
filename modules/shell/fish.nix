{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.shell.fish;
in {
  options.modules.shell.fish = {
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
          c = "clear";
          cla = "clear; exec fish";

          ls = "lb";
          ll = "lb -l";
          la = "lb -A";
          lla = "lb -lA";

          ip = "ip -c";
          ipa = "ip addr";

          qlog = "clear && tail -f ~/.local/share/qtile/qtile.log";

          v = "nvim .";
          ranger = ''ranger --choosedir=/tmp/ranger_dir; set LASTDIR (cat /tmp/ranger_dir); cd $LASTDIR; rm /tmp/ranger_dir'';
          cam = ''mpv av://v4l2:/dev/video0 --profile=low-latency --untimed'';

          vc = "python -m venv .venv";
          va = "source .venv/bin/activate.fish";
          vv = "source .venv/bin/activate.fish && nvim .";

          ".." = "cd ..";
          "..." = "cd ../..";
          "...." = "cd ../../..";
          cb = "cd -";

          man = "batman";

          gs = "git status -s";
          gss = "git status";
          gad = "git add .";
          gd = "git diff";
          gp = "git push";
          gpl = "git pull";
          gf = "git push --force-with-lease";
        };
        shellAbbrs = {
          ga = "git add";
          gc = "git commit";
          gcm = "git commit -m";
          gcam = "git commit -am";
          gca = "git commit --amend";
          gdh = "git diff HEAD^";
        };
        shellInit = builtins.readFile "${config.dotfiles.config}/fish/config.fish";
        interactiveShellInit =
          /*
          fish
          */
          ''
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
          lb = {
            body = builtins.readFile "${config.dotfiles.config}/fish/functions/lb.fish";
            description = "ls on directory, bat on file";
            wraps = "ls";
          };
        };
      };
    };
    environment.shells = with pkgs; [fish];
    users.defaultUserShell = pkgs.fish;
    programs.fish.enable = true;
  };
}
