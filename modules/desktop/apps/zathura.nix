{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.modules.desktop.zathura;
in {
  options.modules.desktop.zathura.enable = mkEnableOption "zathura";
  config = mkIf cfg.enable {
    home.programs.zathura = {
      enable = true;
      mappings = {
        j = "feedkeys 5<Down>";
        k = "feedkeys 5<Up>";
        J = "feedkeys <C-d>";
        K = "feedkeys <C-u>";
      };
      options = {
        "selection-clipboard" = "clipboard";
        "show-hidden" = true;
        "statusbar-home-tilde" = true;
        "window-title-basename" = true;
        "recolor" = false;
        "adjust-open" = "best-fit";
      };
    };
  };
}
