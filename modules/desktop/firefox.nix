{ config, lib, pkgs, ... }:
with lib;
with lib.my;
let
    cfg = config.modules.desktop.firefox;
    cfg_profile = config.home.programs.firefox.profiles.${config.user.name};
    extension_name = "yaru_orange@ava.xpi";
    extension_path = ".mozilla/firefox/${cfg_profile.name}/extensions/${extension_name}";
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
                userChrome = builtins.readFile "${config.dotfiles.config}/firefox/userChrome.css";
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
        home.home.file.${extension_path}.source = "${config.dotfiles.config}/firefox/${extension_name}";
    };
}
