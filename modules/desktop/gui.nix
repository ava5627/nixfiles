{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  gtk_cfg = config.modules.desktop.gtk;
  qt_cfg = config.modules.desktop.qt;
in {
  options.modules.desktop = {
    gtk.enable = mkBool true "GTK";
    qt.enable = mkBool true "QT";
  };
  config = mkMerge [
    (mkIf gtk_cfg.enable {
      home.gtk = {
        enable = true;
        gtk2 = {
          configLocation = "${config.home.xdg.configHome}/gtk-2.0/gtkrc";
        };
        font = {
          package = pkgs.noto-fonts;
          name = "Noto Sans";
          size = 11;
        };
      };
    })
    (mkIf qt_cfg.enable {
      qt = {
        enable = true;
      };
      home.qt = {
        enable = true;
      };
    })
  ];
}
