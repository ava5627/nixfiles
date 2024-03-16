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
    autoStart = mkBool true "Start Discord on login";
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

    modules.autoStart = mkIf cfg.autoStart [
      "discord"
    ];
    system.userActivationScripts.betterDiscord.text = let
      plugins = lib.concatStringsSep " " (map (x: "\"${x}\"") cfg.plugins);
      themes = lib.concatStringsSep " " (map (x: "\"${x}\"") cfg.themes);
    in
      /*
      bash
      */
      ''
        if [ ! -d $XDG_CONFIG_HOME/BetterDiscord ] ; then
          mkdir -p $XDG_CONFIG_HOME/BetterDiscord/themes
          mkdir -p $XDG_CONFIG_HOME/BetterDiscord/plugins
          mkdir -p $XDG_CONFIG_HOME/BetterDiscord/data/stable
          ${pkgs.betterdiscordctl}/bin/betterdiscordctl install
          echo "{" > $XDG_CONFIG_HOME/BetterDiscord/data/stable/plugins.json
          for plugin in ${plugins}; do
            ${pkgs.wget}/bin/wget $plugin -O $XDG_CONFIG_HOME/BetterDiscord/plugins/$(basename $plugin)
            plugin_name=$(basename $plugin | cut -d'.' -f1)
            echo "  \"$plugin_name\": true," >> $XDG_CONFIG_HOME/BetterDiscord/data/stable/plugins.json
          done
          echo "  \"dummy\": false" >> $XDG_CONFIG_HOME/BetterDiscord/data/stable/plugins.json
          echo "}" >> $XDG_CONFIG_HOME/BetterDiscord/data/stable/plugins.json
          echo "{" > $XDG_CONFIG_HOME/BetterDiscord/data/stable/themes.json
          for theme in ${themes}; do
            ${pkgs.wget}/bin/wget $theme -O $XDG_CONFIG_HOME/BetterDiscord/themes/$(basename $theme)
            theme_name=$(basename $theme | cut -d'.' -f1)
            echo "  \"$theme_name\": true," >> $XDG_CONFIG_HOME/BetterDiscord/data/stable/themes.json
          done
          echo "  \"dummy\": false" >> $XDG_CONFIG_HOME/BetterDiscord/data/stable/themes.json
          echo "}" >> $XDG_CONFIG_HOME/BetterDiscord/data/stable/themes.json
        fi
      '';
  };
}
