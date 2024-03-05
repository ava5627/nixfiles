{ config, lib, pkgs, ... }:
with lib;
with lib.my;
let cfg = config.modules.desktop.firefox;
in
{
    options.modules.desktop.firefox = {
        enable = mkBool true "firefox";
    };

    config = mkIf cfg.enable {
        environment.systemPackages = with pkgs; [
            firefox
        ];
        home.programs.firefox = {
            enable = true;
            profiles.${config.user.name} = {
                name = "${config.user.name}";
                isDefault = true;
                userChrome = builtins.readFile "${config.dotfiles.config}/userChrome.css";
                settings = {
                    # Tell Firefox to sync the toolbar layout
                    "services.sync.prefs.sync.browser.uiCustomization.state" = true;
                    "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
                    "browser.tabs.inTitlebar" = 0;
                    "browser.toolbars.bookmarks.visibility" = "always";
                    "browser.disableResetPrompt" = true;
                    "browser.onboarding.enabled" = false;
                    "browser.aboutConfig.showWarning" = false;
                    "media.videocontrols.picture-in-picture.video-toggle.enabled" = false;
                };
            };
        };
    };
}
