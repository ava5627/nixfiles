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
                delta.enable = true;
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
