{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.discord;
in {
  options.modules.desktop.discord = {
    enable = mkEnableOption "Discord";
    plugins = mkOption {
      type = types.listOf types.str;
      default = [];
    };
    themes = mkOption {
      type = types.listOf types.str;
      default = [];
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs;
      [
        discord
        betterdiscordctl
      ];

    system.userActivationScripts.betterDiscord.text = let
      plugins = lib.concatStringsSep " " (map (x: "\"x\"") cfg.plugins);
      themes = lib.concatStringsSep " " (map (x: "\"x\"") cfg.themes);
    in
      /*
      bash
      */
      ''
        if [ ! -d ~/.config/BetterDiscord ] ; then
          mkdir -p ~/.config/BetterDiscord/themes
          mkdir -p ~/.config/BetterDiscord/plugins
          mkdir -p ~/.config/BetterDiscord/data/stable
          ${pkgs.betterdiscordctl}/bin/betterdiscordctl install
          echo "{" > ~/.config/BetterDiscord/data/stable/plugins.json
          for plugin in ${plugins}; do
            ${pkgs.wget}/bin/wget $plugin -o ~/.config/BetterDiscord/plugins/$(basename $plugin)
            plugin_name=$(basename $plugin | cut -d'.' -f1)
            echo "  \"$plugin_name\": true," >> ~/.config/BetterDiscord/data/stable/plugins.json
          done
          echo "}" >> ~/.config/BetterDiscord/data/stable/plugins.json
          echo "{" > ~/.config/BetterDiscord/data/stable/themes.json
          for theme in ${themes}; do
            ${pkgs.wget}/bin/wget $theme -o ~/.config/BetterDiscord/themes/$(basename $theme)
            theme_name=$(basename $theme | cut -d'.' -f1)
            echo "  \"$theme_name\": true," >> ~/.config/BetterDiscord/data/stable/themes.json
          done
          echo "}" >> ~/.config/BetterDiscord/data/stable/themes.json
        fi
      '';
  };
}
