{ config, lib, ...}:
with lib;
with lib.my;
let cfg = config.modules.shell.git;
in {
    options.modules.shell.git = with types; {
        enable = mkBool true "git";
        userName = mkOpt str "ava5627";
        userEmail = mkOpt str "avasharris1@gmail.com";
    };

    config = mkIf cfg.enable {
        home.programs = {
            git = {
                enable = true;
                userName = cfg.userName;
                userEmail = cfg.userEmail;
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
        };
    };
}
