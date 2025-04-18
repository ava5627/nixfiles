{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  iniFormat = pkgs.formats.ini {};
  cfg = config.modules.desktop.dunst;
in {
  options.modules.desktop.dunst.enable = mkEnableOption "Dunst";
  config = mkIf cfg.enable {
    home.services.dunst = {
      enable = true;
    };
    home.xdg.configFile."dunst/dunstrc".source = iniFormat.generate "dunstrc" {
      global = {
        icon_theme = config.home.gtk.iconTheme.name or "";
        enable_recursive_icon_lookup = true;
        monitor = 0;
        follow = "mouse";
        width = "(200, 600)";
        height = 200;
        origin = "top_right";
        offset = "15x49";
        scale = 0;
        notification_limit = 20;
        progress_bar = true;
        progress_bar_height = 10;
        progress_bar_frame_width = 1;
        progress_bar_min_width = 150;
        progress_bar_max_width = 300;
        indicate_hidden = "yes";
        transparency = 0;
        separator_height = 2;
        padding = 6;
        horizontal_padding = 6;
        text_icon_padding = 0;
        frame_width = 3;
        separator_color = "frame";
        sort = "no";
        idle_threshold = 0;
        font = "Noto Sans 11";
        line_height = 3;
        markup = "full";
        format = "\"<b>%s</b>\\n%b\"";
        alignment = "center";
        vertical_alignment = "center";
        show_age_threshold = -1;
        ellipsize = "end";
        ignore_newline = "no";
        stack_duplicates = true;
        hide_duplicate_count = true;
        show_indicators = "no";
        word_wrap = "yes";
        icon_position = "left";
        min_icon_size = 22;
        max_icon_size = 80;
        sticky_history = "yes";
        history_length = 15;
        dmenu = "${pkgs.rofi}/bin/rofi -dmenu -theme styles/dunst.rasi";
        browser = "${pkgs.firefox}/bin/firefox";
        always_run_script = true;
        title = "Dunst";
        class = "Dunst";
        corner_radius = 10;
        ignore_dbusclose = false;
        force_xwayland = false;
        force_xinerama = false;
        mouse_left_click = "do_action, close_current";
        mouse_middle_click = "context, close_current";
        mouse_right_click = "close_all";
        timeout = "10s";
      };
    };
  };
}
