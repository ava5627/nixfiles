{ options, config, lib, ... }:

with lib;
with lib.my;
{
    options = with types;{
        user = mkOpt attrs {};
        dotfiles = {
            dir = mkOpt path (toString ../.);

            bin = mkOpt path "${config.dotfiles.dir}/bin";
            config = mkOpt path "${config.dotfiles.dir}/config";
            modules = mkOpt path "${config.dotfiles.dir}/modules";
            homeModules = mkOpt path "${config.dotfiles.dir}/home/modules";
            themes = mkOpt path "${config.dotfiles.homeModules}/themes";
        };

        home = mkOpt attrs {};
    };

    config = {
        user = let
            user = builtins.getEnv "USER";
            name = if elem user [ "" "root" ] then "ava" else user;
        in {
            inherit name;
            description = "The primary user account";
            extraGroups = [ "wheel" "networkmanager" "docker" ];
            isNormalUser = true;
            home = "/home/${name}";
            group = "users";
            uid = 1000;
        };
        users.users.${config.user.name} = mkAliasDefinitions options.user;

        nix.settings = let users = [ "root" config.user.name ]; in {
            trusted-users = users;
            allowed-users = users;
        };

        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {
            dotfiles = config.dotfiles;
        };
        home-manager.users.${config.user.name} = (mkMerge [
            config.home
            ../home
        ]);

    };
}