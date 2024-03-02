{ pkgs, ...}:
{
    services.dunst = {
        enable = true;
        settings = {
            global = {
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
				frame_color = "#8EC07C";
				vertical_alignment = "center";
				show_age_threshold = -1;
				ellipsize = "end";
				ignore_newline = "no";
				stack_duplicates = true;
				hide_duplicate_count = true;
				show_indicators = "no";
				word_wrap = "yes";
				icon_position = "left";
				min_icon_size = 20;
				max_icon_size = 80;
				sticky_history = "yes";
				history_length = 15;
				dmenu = "${pkgs.rofi}/bin/rofi -dmenu -theme $HOME/.config/rofi/styles/dunst/style.rasi";
				browser = "xdg-open";
				always_run_script = true;
				title = "Dunst";
				class = "Dunst";
				corner_radius = 10;
				ignore_dbusclose = false;
				force_xwayland = false;
				force_xinerama = false;
				mouse_left_click = [ "do_action" "close_current" ];
				mouse_middle_click = [ "context" "close_current" ];
				mouse_right_click = "close_all";
            };
            urgency_low = {
                background = "#16161e";
                foreground = "#c0caf5";
                frame_color = "#c0caf5";
                timeout = "10s";
            };
            urgency_normal = {
                background = "#1a1b26";
                frame_color = "#3d59a1";
                foreground = "#7aa2f7";
                timeout = "10s";
            };
            urgency_critical = {
                background = "#292e42";
                foreground = "#db4b4b";
                frame_color = "#db4b4b";
                timeout = "10s";
            };
        };
    };
}
