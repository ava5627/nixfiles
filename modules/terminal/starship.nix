{
  config,
  lib,
  ...
}:
with lib;
with lib.my; let
  # inherit (config.home.lib.file) mkOutOfStoreSymlink;
  cfg = config.modules.terminal.starship;
in {
  options.modules.terminal.starship.enable = mkBool true "Starship prompt";
  config = mkIf cfg.enable {
    home = {
      programs.starship = {
        enable = true;
      };
      xdg.configFile."starship.toml" = {
        source = "${config.dotfiles.config}/starship.toml";
        # source = mkOutOfStoreSymlink "${config.home.home.homeDirectory}/nixfiles/config/starship.toml";
      };
    };
  };
}
