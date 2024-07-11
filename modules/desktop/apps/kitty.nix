{
  config,
  lib,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.kitty;
in {
  options.modules.desktop.kitty.enable = mkEnableOption "Kitty";

  config = mkIf cfg.enable {
    home.programs.kitty = {
      enable = true;
      font = {
        name = "Source Code Pro";
        size = 10;
      };
      settings = {
        background_opacity = "0.97";
        confirm_os_window_close = 0;
        macos_option_as_alt = true;
      };
      shellIntegration.enableFishIntegration = true;
    };
    environment.variables.TERMINAL = "kitty";
  };
}
