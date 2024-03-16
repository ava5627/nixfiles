{
  options,
  config,
  lib,
  username,
  inputs,
  ...
}:
with lib;
with lib.my; {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    # home-manager.users.${config.user.name} is long, so we alias it to home
    (lib.mkAliasOptionModule ["home"] ["home-manager" "users" "${config.user.name}"])
  ];
  options = with types; {
    user = mkOpt attrs {};
    dotfiles = {
      dir = mkOpt path (toString ../.);

      bin = mkOpt path "${config.dotfiles.dir}/bin";
      config = mkOpt path "${config.dotfiles.dir}/config";
      modules = mkOpt path "${config.dotfiles.dir}/modules";
      homeModules = mkOpt path "${config.dotfiles.dir}/home/modules";
      themes = mkOpt path "${config.dotfiles.homeModules}/themes";
    };
    modules.autoStart = mkOpt (listOf str) [];
    launchAll = mkBool true "Launch all services on startup";
  };

  config = {
    user = let
      name = username;
    in {
      inherit name;
      description = "The primary user account";
      extraGroups = ["wheel" "networkmanager" "docker"];
      isNormalUser = true;
      home = "/home/${name}";
      group = "users";
      uid = 1000;
    };
    users.users.${config.user.name} = mkAliasDefinitions options.user;

    nix.settings = let
      users = ["root" config.user.name];
    in {
      trusted-users = users;
      allowed-users = users;
    };

    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;

    home = {
      # This value determines the Home Manager release that your configuration is
      # compatible with. This helps avoid breakage when a new Home Manager release
      # introduces backwards incompatible changes.
      #
      # You should not change this value, even if you update Home Manager. If you do
      # want to update the value, then make sure to first check the Home Manager
      # release notes.
      home.stateVersion = "23.11"; # Please read the comment before changing.

      # Let Home Manager install and manage itself.
      programs.home-manager.enable = true;
    };
  };
}
