{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.shell.programs;
in {
  options.modules.shell.programs.enable = mkBool true "Usefull shell programs";
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      neofetch # system info
      fd # find replacement
      stow # symlink manager
      jq # json processor
      tlrc # explain commands
      xdg-ninja # search for .files in home directory that can be moved
      dua # disk usage analyzer
      ffmpeg # multimedia framework
      glow # terminal markdown viewer
    ];
    home.programs = {
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
    };
  };
}
