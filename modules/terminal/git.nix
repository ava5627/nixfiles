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
          ignores = [".ropeproject" ".envrc" ".direnv" "__pycache__" ".vscode" ".ipynb_checkpoints" ".venv" ".pytest_cache"];
          settings = {
            user.name = cfg.userName;
            user.email = cfg.userEmail;
            init.defaultBranch = "main";
            alias = {
              olog = "log --oneline --decorate --graph";
              dlog = "log -p --ext-diff";
            };
          };
        };
        delta = {
          enable = true;
          enableGitIntegration = true;
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
        gh.enable = true;
        lazygit.enable = true;
        fish.shellAbbrs = {
          ga = "git add";
          gc = "git commit";
          gcm = "git commit -m";
          gcam = "git commit -am";
          gce = "git commit --amend -a --no-edit";
          gdh = "git diff HEAD^";
          gom = "git checkout main";
          grc = "gh repo create --public --source=. ";
          grf = "gh repo fork --remote --clone";
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
        glo = "git log --oneline --decorate --graph";
      };
    };
  };
}
