{
  config,
  lib,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.terminal.git;
in {
  options.modules.terminal.git = with types; {
    enable = mkBool true "git";
    userName = mkOpt str "ava5627";
    userEmail = mkOpt str "avasharris1@gmail.com";
  };

  config = mkIf cfg.enable {
    home = {
      programs = {
        git = {
          enable = true;
          userName = cfg.userName;
          userEmail = cfg.userEmail;
          ignores = [".ropeproject" ".envrc" ".direnv" "__pycache__" ".vscode" ".ipynb_checkpoints" ".venv" ".pytest_cache"];
          extraConfig = {
            init.defaultBranch = "main";
          };
          delta = {
            enable = true;
            options = {
              syntax-theme = "Dracula";
              line-numbers = true;
              side-by-side = true;
              decorations = true;
              hyperlinks = true;
              syntax-highlighting = true;
              commit-decoration = true;
              conflictstyle = "diff3";
              navigate = true;
              file-decoration-style = "omit";
              hunk-header-decoration-style = "omit";
              hunk-header-style = "file line-number syntax";
            };
          };
          aliases = {
            olog = "log --oneline --decorate --graph";
            dlog = "log -p --ext-diff";
          };
        };
        gh.enable = true;
        lazygit.enable = true;
        fish.shellAbbrs = {
          ga = "git add";
          gc = "git commit";
          gcm = "git commit -m";
          gcam = "git commit -am";
          gca = "git commit --amend -a --no-edit";
          gdh = "git diff HEAD^";
          grc = "gh repo create --public --source=. ";
        };
      };
      home.shellAliases = {
        gs = "git status -s";
        gss = "git status";
        gad = "git add .";
        gd = "git diff";
        gp = "git push";
        gl = "git pull";
        gf = "git push --force-with-lease";
      };
    };
  };
}
