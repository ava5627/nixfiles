{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  inherit (config.home.lib.formats.rasi) mkLiteral;
  cfg = config.modules.desktop.rofi;
in {
  options.modules.desktop.rofi = {
    enable = mkEnableOption "rofi";
    wayland = mkEnableOption "rofi for wayland";
  };
  config = mkIf cfg.enable {
    home = {
      programs.rofi = {
        package = pkgs.rofi;
        enable = true;
        cycle = true;
        extraConfig = {
          show-icons = true;
          matching = "fuzzy";
          modi = ["window" "run" "drun" "ssh"];
          kb-remove-word-back = "Control+w,Control+BackSpace";
          kb-remove-word-forward = "Alt+d";
          kb-clear-line = "Control+q";
          kb-row-up = "Up,Control+k";
          kb-row-down = "Down,Control+j";
          kb-row-left = "Control+h";
          kb-row-right = "Control+l";
          kb-mode-complete = "";
          kb-remove-char-back = "BackSpace,Shift+BackSpace";
          kb-accept-entry = "Return,KP_Enter";
          kb-remove-to-eol = "";
        };
        theme = {
          "*" = {
            spacing = 5;
            width = mkLiteral "35%";
          };
          configuration = {
            display-drun = "Applications";
            drun-display-format = "{name}";
          };
          window = {
            border = mkLiteral "1px 1px 1px 1px";
          };
          inputbar = {
            border = mkLiteral "0 0 1px 0";
            children = [(mkLiteral "prompt") (mkLiteral "entry")];
          };
          prompt = {
            padding = mkLiteral "16px";
            border = mkLiteral "0 1px 0 0";
          };
          textbox = {
            border = mkLiteral "0 0 1px 0";
            padding = mkLiteral "8px 16px";
          };
          entry = {
            padding = mkLiteral "16px";
          };
          listview = {
            padding = mkLiteral "1% 0.5% 1% 0.75%";
            columns = 2;
            lines = 8;
            dynamic = true;
            layout = mkLiteral "vertical";
          };
          element = {
            padding = mkLiteral "8px";
          };
          "element selected" = {
            border = mkLiteral "1px 1px 1px 1px";
          };
        };
      };
      xdg.configFile."rofi/styles" = {
        source = "${config.dotfiles.config}/rofi/styles";
        recursive = true;
      };
    };
  };
}
