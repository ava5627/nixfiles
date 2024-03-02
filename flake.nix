{
    description = "NixOS configuration";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        home-manager.url = "github:nix-community/home-manager";
        home-manager.inputs.nixpkgs.follows = "nixpkgs";
        nix-gc-env.url = "github:Julow/nix-gc-env";
    };

    outputs = inputs@{ self, nixpkgs, home-manager, nur, ... }:
    let
        system = "x86_64-linux";
    in
    {
        nixosConfigurations = {
            nixos = nixpkgs.lib.nixosSystem {
                inherit system;
                specialArgs = inputs;
                modules = [
                    ./hosts/virtualbox/hardware-configuration.nix
                    ./configuration.nix
                    home-manager.nixosModules.home-manager
                ];
            };
        };
    };
}

