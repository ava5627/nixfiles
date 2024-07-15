{config, pkgs, ...}: {
  environment = {
    sessionVariables = {
      # Xdg directories
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_STATE_HOME = "$HOME/.local/state";
    };

    variables = {
      NPM_CONFIG_USERCONFIG = "$XDG_CONFIG_HOME/npm/npmrc";
      CUDA_CACHE_PATH = "$XDG_CACHE_HOME/nv";
      HISTFILE = "$XDG_STATE_HOME/bash/history";
      GNUPGHOME = "$XDG_DATA_HOME/gnupg";
      SCREENRC = "$XDG_CONFIG_HOME/screen/screenrc";
      NUGET_PACKAGES = "$XDG_CACHE_HOME/NuGetPackages";
      GOPATH = "$XDG_CONFIG_HOME/go";
      ANDROID_HOME = "$XDG_DATA_HOME/android";
      GRADLE_USER_HOME = "$XDG_DATA_HOME/gradle";
      MYSQL_HISTFILE = "$XDG_DATA_HOME/mysql_history";
      ZDOTDIR = "$HOME/.config/zsh";
      PARALLEL_HOME = "$XDG_DATA_HOME/parallel";
      WGETRC = "$XDG_CONFIG_HOME/wgetrc";
      DOCKER_CONFIG = "$XDG_CONFIG_HOME/docker";
      NODE_REPL_HISTORY_FILE = "$XDG_DATA_HOME/node_repl_history";
      XCOMPOSECACHE = "$XDG_CACHE_HOME/X11/compose";
    };
  };
  xdg = {
    mime = {
      defaultApplications = {
        # PDF -> firefox
        "application/pdf" = "firefox.desktop";
        # zip -> file-roller or firefox
        "application/zip" = ["org.gnome.FileRoller.desktop"];
        # folders -> pcmanfm
        "inode/directory" = "pcmanfm.desktop";
        # images -> geeqie, feh, or gimp
        "image/*" = ["org.geeqie.Geeqie.desktop" "feh.desktop" "gimp.desktop"];
        "image/png" = ["org.geeqie.Geeqie.desktop" "feh.desktop" "gimp.desktop"];
        "image/jpeg" = ["org.geeqie.Geeqie.desktop" "feh.desktop" "gimp.desktop"];
        "image/gif" = ["org.geeqie.Geeqie.desktop" "feh.desktop" "gimp.desktop"];
        "image/jpg" = ["org.geeqie.Geeqie.desktop" "feh.desktop" "gimp.desktop"];
      };
    };
    portal = {
      enable = true;
      config.common.default = "*";
      extraPortals = [ pkgs.xdg-desktop-portal-xapp ];
    };
  };
  home.xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
    };
    configFile = {
      "ideavim/ideavimrc".source = "${config.dotfiles.config}/ideavimrc";
      "ipython/profile_default/ipython_config.py".source = "${config.dotfiles.config}/ipython_config.py";
      wgetrc.text = "hsts-file = $XDG_CACHE_HOME/wget-hsts";
      "npm/npmrc".text = ''
        prefix=$XDG_DATA_HOME/npm
        cache=$XDG_CACHE_HOME/npm
        init-module=$XDG_CONFIG_HOME/npm/npm-init.js
        tmp=$XDG_RUNTIME_DIR/npm
      '';
    };
  };
}
