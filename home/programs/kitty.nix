{ pkgs, ... }:
{
    programs.kitty = {
        enable = true;
        font = {
            name = "Source Code Pro";
            size = if pkgs.system == "x86_64-linux" then 10 else 12;
        };
        settings = {
            background_opacity = "0.97";
            confirm_os_window_close = 0;
            macos_option_as_alt = true;
        };
        shellIntegration.enableFishIntegration = true;
    };
}
