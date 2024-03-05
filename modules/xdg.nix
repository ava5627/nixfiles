{ ... }:
{
    environment = {
        sessionVariables = {
            # Xdg directories
            XDG_CONFIG_HOME = "$HOME/.config";
            XDG_CACHE_HOME = "$HOME/.cache";
            XDG_DATA_HOME = "$HOME/.local/share";
            XDG_STATE_HOME = "$HOME/.local/state";
        };

        variables = {
            EDITOR = "nvim";
            MANPAGER = "sh -c 'col -bx | bat -l man -p'";
            MANROFFOPT = "-c";

            NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc";
            CUDA_CACHE_PATH="$XDG_CACHE_HOME/nv";
            HISTFILE="$XDG_STATE_HOME/bash/history";
            GNUPGHOME="$XDG_DATA_HOME/gnupg";
            SCREENRC="$XDG_CONFIG_HOME/screen/screenrc";
            GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc";
            NUGET_PACKAGES="$XDG_CACHE_HOME/NuGetPackages";
            KERAS_HOME="$XDG_STATE_HOME/keras";
            XINITRC="$XDG_CONFIG_HOME/X11/xinitrc";
            GOPATH="$XDG_CONFIG_HOME/go";
            ANDROID_HOME="$XDG_DATA_HOME/android";
            GRADLE_USER_HOME="$XDG_DATA_HOME/gradle";
            MYSQL_HISTFILE="$XDG_DATA_HOME/mysql_history";
            ZDOTDIR="$HOME/.config/zsh";
            PARALLEL_HOME="$XDG_DATA_HOME/parallel";
            RUSTUP_HOME="$XDG_DATA_HOME/rustup";
            CARGO_HOME="$XDG_DATA_HOME/cargo";
            WGETRC="$XDG_CONFIG_HOME/wgetrc";
            VIRTUAL_ENV_DISABLE_PROMPT="1";
            DOCKER_CONFIG="$XDG_CONFIG_HOME/docker";
            NODE_REPL_HISTORY_FILE="$XDG_DATA_HOME/node_repl_history";
            XCOMPOSECACHE="$XDG_CACHE_HOME/X11/compose";
        };
    };
}
