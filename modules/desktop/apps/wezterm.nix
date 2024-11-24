{
  config,
  lib,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.wezterm;
in {
  options.modules.desktop.wezterm.enable = mkBool false "Wezterm";
  config = mkIf cfg.enable {
    home.programs.wezterm = {
      enable = true;
      extraConfig =
        /*
        lua
        */
        ''
          local config = wezterm.config_builder()

          config.color_scheme = 'Tokyo Night'

          config.font = wezterm.font("Source Code Pro", { weight = "DemiBold" })
          config.font_size = 10
          config.window_background_opacity = 0.97

          config.window_padding = {
              left = 0,
              right = 0,
              top = 0,
              bottom = 0,
          }

          config.window_close_confirmation = "NeverPrompt"

          -- tab bar
          config.hide_tab_bar_if_only_one_tab = true
          config.use_fancy_tab_bar = false
          config.tab_bar_at_bottom = true

          -- cursor
          config.default_cursor_style = "BlinkingBar"
          config.cursor_blink_ease_in = "Constant"
          config.cursor_blink_ease_out = "Constant"
          config.cursor_blink_rate = 600;

          -- and finally, return the configuration to wezterm
          return config
        '';
    };
  };
}
