{
  pkgs,
  lib,
  ...
}:
with lib.my; {
  programs = {
    btop = {
      enable = true;
      settings = {
        color_theme = "dracula";
        theme_background = false;
        vim_keys = true;
      };
    };
    lsd.enable = true;
    ripgrep.enable = true;
    zoxide.enable = true;
    bat = {
      enable = true;
      extraPackages = with pkgs.bat-extras; [batman];
    };
    fzf.enable = true;
    carapace.enable = true;
    navi.enable = true;
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
      vimdiffAlias = true;
      withNodeJs = true;
      withPython3 = true;
    };
    mpv = {
      enable = true;
      scripts = [pkgs.mpvScripts.mpris];
    };
    obs-studio.enable = true;
  };
  services = {
    playerctld.enable = true;
    kdeconnect = {
      enable = true;
      indicator = true;
    };
  };
}
