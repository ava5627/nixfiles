{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.terminal.programs;
in {
  options.modules.terminal.programs.enable = mkBool true "Useful terminal programs";
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      fastfetch # system info
      fd # find replacement
      stow # symlink manager
      jaq # json processor
      tlrc # explain commands
      xdg-ninja # search for .files in home directory that can be moved
      dua # disk usage analyzer
      ffmpeg # multimedia framework
      glow # terminal markdown viewer
      difftastic # diff viewer
      jq # json processor
      lazydocker # docker manager
      psmisc # process management
      procps # process management
      unzip # zip file extractor
      wget # web requests
      curl # web requests
      file # file type identification
      gnumake # make
      gcc # c compiler
    ];
    home = {
      programs = {
        btop = {
          enable = true;
          settings = {
            theme_background = false;
            vim_keys = true;
            shown_boxes = "proc cpu mem net gpu0";
            proc_sorting = "memory";
            proc_aggregate = true;
          };
          package = pkgs.btop.override {cudaSupport = true;};
        }; # system monitor
        eza = {
          enable = true;
          icons = "auto";
        }; # ls replacement
        ripgrep.enable = true; # grep replacement
        zoxide = {
          enable = true;
          options = ["--cmd cd"];
        }; # cd replacement
        bat = {
          enable = true;
          extraPackages = with pkgs.bat-extras; [batman];
        }; # cat replacement
        fzf.enable = true; # fuzzy finder
        direnv = {
          enable = true;
          nix-direnv.enable = true;
        }; # environment manager
      };
      home.shellAliases = {
        man = "batman";
        cb = "cd -"; # go back
        ls = "lb";
      };
    };
    environment.variables = {
      MANPAGER = "sh -c 'col -bx | bat -l man -p'"; # use bat as man pager
      MANROFFOPT = "-c";
    };
    home.xdg.configFile."fastfetch".source = "${config.dotfiles.config}/fastfetch";
  };
}
