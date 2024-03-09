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
      rofi # application launcher and menu
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
        "rofi" = {
          source = "${config.dotfiles.config}/rofi";
          recursive = true;
        };
        "copyq/" = {
          source = "${config.dotfiles.config}/copyq";
          recursive = true;
        };
      };
    };
  };
}
