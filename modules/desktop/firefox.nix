{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.desktop.firefox;
  cfg_profile = config.home.programs.firefox.profiles.${config.user.name};
  extension_name = "yaru_orange@ava.xpi";
  extension_path = ".mozilla/firefox/${cfg_profile.name}/extensions/${extension_name}";
in {
  options.modules.desktop.firefox.enable = mkEnableOption "Firefox";
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
          "browser.uiCustomization.state" = ''{"placements":{"widget-overflow-fixed-list":["screenshot-button","fxa-toolbar-menu-button","add-ons-button","firefox-view-button"],"unified-extensions-area":["_cb31ec5d-c49a-4e5a-b240-16c767444f62_-browser-action","_6e710c58-36cc-49d6-b772-bfc3030fa56e_-browser-action","firefoxcolor_mozilla_com-browser-action","_c3c10168-4186-445c-9c5b-63f12b8e2c87_-browser-action","_c961a5ba-dc89-44e9-9e52-93318dd95378_-browser-action","_3385c2d8-dcfd-4f92-adb7-5d8429dee164_-browser-action","https-everywhere_eff_org-browser-action","_2e5ff8c8-32fe-46d0-9fc8-6b8986621f3c_-browser-action","enhancerforyoutube_maximerf_addons_mozilla_org-browser-action","chrome-gnome-shell_gnome_org-browser-action","_b9acf540-acba-11e1-8ccb-001fd0e08bd4_-browser-action","contact_example_com-browser-action","sponsorblocker_ajay_app-browser-action","rivet-for-plutonium_5e_tools-browser-action","sabre_simplify_jobs-browser-action","firefox_tampermonkey_net-browser-action","new-minecraft-wiki-redirect_lordpipe-browser-action","vpn_proton_ch-browser-action","faststream_andrews-browser-action"],"nav-bar":["back-button","forward-button","stop-reload-button","urlbar-container","downloads-button","addon_darkreader_org-browser-action","ublock0_raymondhill_net-browser-action","_24e032ab-bf0b-41ad-b404-79abc127bcbf_-browser-action","_e839c3f9-298e-4cd0-99e0-464431cb7c34_-browser-action","gsconnect_andyholmes_github_io-browser-action","_762f9885-5a13-4abd-9c77-433dcd38b8fd_-browser-action","vim-vixen_i-beam_org-browser-action","fox_replace_fx-browser-action","_aecec67f-0d10-4fa7-b7c7-609a2db280cf_-browser-action","jid1-zadieub7xozojw_jetpack-browser-action","_b2c51689-0095-472b-b900-2b3911fd5089_-browser-action","_506e023c-7f2b-40a3-8066-bc5deb40aebe_-browser-action","_446900e4-71c2-419f-a6a7-df9c091e268b_-browser-action","formhistory_yahoo_com-browser-action","_4b726fbc-aba9-4fa7-97fd-a42c2511ddf7_-browser-action","vimmatic_i-beam_org-browser-action","reset-pbm-toolbar-button","_7d7cad35-2182-4457-972d-5a41a2051240_-browser-action","unified-extensions-button","nordvpnproxy_nordvpn_com-browser-action"],"toolbar-menubar":["menubar-items"],"TabsToolbar":["tabbrowser-tabs","new-tab-button","alltabs-button","sync-button"],"PersonalToolbar":["personal-bookmarks"]},"seen":["save-to-pocket-button","developer-button","enhancerforyoutube_maximerf_addons_mozilla_org-browser-action","_e839c3f9-298e-4cd0-99e0-464431cb7c34_-browser-action","addon_darkreader_org-browser-action","chrome-gnome-shell_gnome_org-browser-action","https-everywhere_eff_org-browser-action","_2e5ff8c8-32fe-46d0-9fc8-6b8986621f3c_-browser-action","ublock0_raymondhill_net-browser-action","_24e032ab-bf0b-41ad-b404-79abc127bcbf_-browser-action","firefoxcolor_mozilla_com-browser-action","gsconnect_andyholmes_github_io-browser-action","_3385c2d8-dcfd-4f92-adb7-5d8429dee164_-browser-action","_762f9885-5a13-4abd-9c77-433dcd38b8fd_-browser-action","vim-vixen_i-beam_org-browser-action","fox_replace_fx-browser-action","_aecec67f-0d10-4fa7-b7c7-609a2db280cf_-browser-action","jid1-zadieub7xozojw_jetpack-browser-action","_446900e4-71c2-419f-a6a7-df9c091e268b_-browser-action","_b9acf540-acba-11e1-8ccb-001fd0e08bd4_-browser-action","_c961a5ba-dc89-44e9-9e52-93318dd95378_-browser-action","_c3c10168-4186-445c-9c5b-63f12b8e2c87_-browser-action","_b2c51689-0095-472b-b900-2b3911fd5089_-browser-action","formhistory_yahoo_com-browser-action","_4b726fbc-aba9-4fa7-97fd-a42c2511ddf7_-browser-action","contact_example_com-browser-action","vimmatic_i-beam_org-browser-action","_6e710c58-36cc-49d6-b772-bfc3030fa56e_-browser-action","sponsorblocker_ajay_app-browser-action","rivet-for-plutonium_5e_tools-browser-action","sabre_simplify_jobs-browser-action","firefox_tampermonkey_net-browser-action","_506e023c-7f2b-40a3-8066-bc5deb40aebe_-browser-action","new-minecraft-wiki-redirect_lordpipe-browser-action","_cb31ec5d-c49a-4e5a-b240-16c767444f62_-browser-action","_7d7cad35-2182-4457-972d-5a41a2051240_-browser-action","vpn_proton_ch-browser-action","nordvpnproxy_nordvpn_com-browser-action","faststream_andrews-browser-action"],"dirtyAreaCache":["nav-bar","PersonalToolbar","toolbar-menubar","TabsToolbar","widget-overflow-fixed-list","unified-extensions-area"],"currentVersion":20,"newElementCount":57}'';
        };
      };
    };
    home.home.file.${extension_path}.source = "${config.dotfiles.config}/firefox/${extension_name}";
  };
}
