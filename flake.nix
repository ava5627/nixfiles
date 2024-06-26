{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-gc-env.url = "github:Julow/nix-gc-env";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    foundry-vtt.url = "github:reckenrode/nix-foundryvtt";
  };

  outputs = inputs @ {nixpkgs, ...}: let
    inherit (lib.my) mapHosts;
    system = "x86_64-linux";
    lib = nixpkgs.lib.extend (final: prev: {
      my = import ./lib {
        inherit inputs;
        lib = final;
      };
    });
    username = "ava";
  in {
    nixosConfigurations =
      mapHosts ./hosts {inherit system username;};

    formatter.${system} = nixpkgs.legacyPackages.${system}.alejandra;
  };
}
