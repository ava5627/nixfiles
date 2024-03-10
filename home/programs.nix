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
        theme_background = false;
        vim_keys = true;
      };
    };
    lsd.enable = true;
    ripgrep.enable = true;
    zoxide = {
      enable = true;
      options = ["--cmd cd"];
    };
    bat = {
      enable = true;
      extraPackages = with pkgs.bat-extras; [batman];
    };
    fzf.enable = true;
    navi = {
      enable = true;
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
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
