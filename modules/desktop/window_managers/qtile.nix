{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.qtile;
in {
  options.modules.desktop.qtile = {
    enable = mkEnableOption "qtile";
    configUrl = mkOpt types.str "https://github.com/ava5627/qtile-config";
  };

  config = mkIf cfg.enable {
    services.xserver = {
      enable = true;
      windowManager.qtile = {
        enable = true;
        extraPackages = p:
          with p; [
            xlib
            pillow
            qtile-extras
          ];
      };
    };
    services.picom.enable = true;
    home.programs.feh.enable = true;
    modules.autoStart = [
      "feh --no-fehbg --bg-scale $HOME/Pictures/Wallpapers/camp_fire.jpg"
    ];

    environment.systemPackages = with pkgs; [
      xcolor # color picker
    ];
    system.userActivationScripts = {
      qtile.text =
        /*
        bash
        */
        ''
          if [ ! -d $XDG_CONFIG_HOME/qtile/.git ]; then
              mkdir -p $XDG_CONFIG_HOME/qtile
              rm $XDG_CONFIG_HOME/colors.json || true
              rm $XDG_CONFIG_HOME/autostart.sh || true
              ${pkgs.git}/bin/git clone ${cfg.configUrl} $XDG_CONFIG_HOME/qtile
          fi
        '';
    };
    home.xdg.configFile."qtile/autostart.sh" = {
      text = ''
        #!/usr/bin/env bash
        ${concatStringsSep " &\n" config.modules.autoStart} &
      '';
      executable = true;
    };
    home.home.shellAliases = {
      qlog = "clear && tail -f ~/.local/share/qtile/qtile.log -n 50";
    };
  };
}
