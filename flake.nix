{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    nixos-hardware.inputs.nixpkgs.follows = "nixpkgs";
    foundry-vtt.url = "github:reckenrode/nix-foundryvtt";
    foundry-vtt.inputs.nixpkgs.follows = "nixpkgs";
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
    catppuccin.url = "github:catppuccin/nix";
    catppuccin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs @ {nixpkgs, ...}: let
    # look in lib/*.nix for how this works
    lib = nixpkgs.lib.extend (final: prev: {
      my = import ./lib {
        inherit inputs;
        lib = final;
      };
    });
    inherit (lib.my) mapHosts mapModules;
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    username = "ava";
  in {
    nixosConfigurations =
      mapHosts ./hosts {inherit system username;};

    formatter.${system} = pkgs.alejandra;

    packages.${system} = mapModules ./packages (p: pkgs.callPackage p {});
  };
}
