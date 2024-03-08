{ config, lib, pkgs, ... }:
with lib;
with lib.my;
let cfg = config.modules.editors.nvim;
in {
    options.modules.editors.nvim = with types;{
        enable = mkBool true "neovim";
        configUrl = mkOpt str "https://github.com/ava5627/nvim";
    };

    config = mkIf cfg.enable {
        home.programs.neovim = {
            enable = true;
            defaultEditor = true;
            vimAlias = true;
            vimdiffAlias = true;
            withNodeJs = true;
            withPython3 = true;
        };
        environment.variables = { EDITOR = "nvim"; };
        environment.systemPackages = with pkgs; [
            python3Packages.python-lsp-server # python language server
        ];
        system.userActivationScripts = {
            neovim.text = ''
                if [ ! -d $XDG_CONFIG_HOME/nvim ]; then
                    ${pkgs.git}/bin/git  clone ${cfg.configUrl} $XDG_CONFIG_HOME/nvim
                fi
            '';
        };
    };
}
