{
  programs.zathura = {
    enable = true;
    mappings = {
      j = "feedkeys 5<Down>";
      k = "feedkeys 5<Up>";
      J = "feedkeys <C-d>";
      K = "feedkeys <C-u>";
    };
    options = {
      "selection-clipboard" = "clipboard";
      "show-hidden" = true;
      "statusbar-home-tilde" = true;
      "window-title-basename" = true;
      "recolor" = false;
      "adjust-open" = "best-fit";
      "completion-bg" = "#16161e";
      "completion-fg" = "#c0caf5";
      "completion-group-bg" = "#3b4261";
      "completion-group-fg" = "#c0caf5";
      "completion-highlight-bg" = "#33467c";
      "completion-highlight-fg" = "#c0caf5";
      "default-fg" = "#c0caf5";
      "default-bg" = "#1a1b26";
      "inputbar-fg" = "#c0caf5";
      "inputbar-bg" = "#1a1b26";
      "notification-fg" = "#a0c980";
      "notification-bg" = "#1a1b26";
      "notification-error-fg" = "#ec7279";
      "notification-error-bg" = "#1a1b26";
      "notification-warning-fg" = "#deb974";
      "notification-warning-bg" = "#1a1b26";
      "tabbar-fg" = "#c0caf5";
      "tabbar-bg" = "#16161e";
      "tabbar-focus-fg" = "#1a1b26";
      "tabbar-focus-bg" = "#d38aea";
      "statusbar-fg" = "#c0caf5";
      "statusbar-bg" = "#1a1b26";
      "highlight-color" = "#3d59a1";
      "highlight-active-color" = "#ff9e64";
      "recolor-darkcolor" = "#c0caf5";
      "recolor-lightcolor" = "#1a1b26";
      "render-loading-bg" = "#deb974";
      "render-loading-fg" = "#1a1b26";
      "index-fg" = "#c0caf5";
      "index-bg" = "#1a1b26";
      "index-active-fg" = "#1a1b26";
      "index-active-bg" = "#7aa2f7";
    };
  };
}
