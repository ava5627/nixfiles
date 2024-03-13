{
  config,
  lib,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.terminal.ranger;
in {
  options.modules.terminal.ranger.enable = mkBool false "Ranger";
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      ranger
    ];
    home = {
      # programs.ranger = {
      #   enable = true;
      #   aliases = {
      #     search = "scout -lstfpe";
      #   };
      #   mappings = {
      #     f = "console scout -ftsea%space";
      #     "<esc>" = "scout -tfp";
      #   };
      # };
      xdg.configFile."ranger".source = "${config.dotfiles.config}/ranger";
      shellAliases = {
        # make ranger use the last directory it was in after exiting
        ranger = ''ranger --choosedir=/tmp/ranger_dir; set LASTDIR (cat /tmp/ranger_dir); cd $LASTDIR; rm /tmp/ranger_dir'';
      };
    };
  };
}
