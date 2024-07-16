{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.dev.python;
in {
  options.modules.dev.python.enable = mkBool true "Python";
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      (python3.withPackages (ps: with ps; [ipython python-lsp-server pyls-isort pylsp-rope python-lsp-black] ++ python-lsp-server.optional-dependencies.all))
      poetry # Python package manager
    ];
    environment.variables = {
      VIRTUAL_ENV_DISABLE_PROMPT = "1";
      KERAS_HOME = "$XDG_STATE_HOME/keras";
    };
    home.home.shellAliases = {
      pyc = "echo layout python > .envrc && direnv allow"; # Use direnv to manage virtualenv
      pyi = "test -f pyproject.toml && poetry install || poetry init"; # Initialize poetry project
    };
  };
}
