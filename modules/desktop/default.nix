{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  config = mkIf config.services.xserver.enable {
    modules.desktop = {
      dunst.enable = true;
      firefox.enable = true;
      flameshot.enable = true;
      gaming.enable = true;
      kitty.enable = true;
      zathura.enable = true;
      rofi.enable = true;
      discord = {
        enable = true;
        plugins = [
          "https://raw.githubusercontent.com/TheCommieAxolotl/BetterDiscord-Stuff/main/Timezones/Timezones.plugin.js"
          "https://github.com/Strencher/BetterDiscordStuff/raw/master/InvisibleTyping/InvisibleTyping.plugin.js"
        ];
        themes = [
          "https://raw.githubusercontent.com/ava5627/nixfiles/main/modules/themes/tokyonight/config/midnight.theme.css"
        ];
      };
    };
    services.xserver = {
      displayManager.sddm = {
        enable = true;
        theme = "${pkgs.my.sugar-candy}";
      };
      xkb = {
        layout = "us";
        variant = "";
        options = "caps:ctrl_modifier";
      };
    };

    environment.systemPackages = with pkgs; [
      xdotool # keyboard and mouse automation
      xclip # clipboard manager
      qalculate-gtk # calculator
      arandr # screen layout editor
      copyq # clipboard manager

      libsForQt5.qt5.qtquickcontrols2 # required for sddm theme
      libsForQt5.qt5.qtgraphicaleffects # required for sddm theme
      # shell scripts
      (writeShellScriptBin "powermenu" (builtins.readFile "${config.dotfiles.bin}/rofi/powermenu"))
      (writeShellScriptBin "edit_configs" (builtins.readFile "${config.dotfiles.bin}/rofi/edit_configs"))
      (writeScriptBin "manage" (builtins.readFile "${config.dotfiles.bin}/manage"))
    ];

    home = {
      programs.feh.enable = true;
      xdg.configFile = {
        "copyq/" = {
          source = "${config.dotfiles.config}/copyq";
          recursive = true;
        };
      };
    };
  };
}
