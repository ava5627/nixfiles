{
    description = "NixOS configuration";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        home-manager.url = "github:nix-community/home-manager";
        home-manager.inputs.nixpkgs.follows = "nixpkgs";
        nix-gc-env.url = "github:Julow/nix-gc-env";
    };

    outputs = inputs@{ self, nixpkgs, home-manager, ... }:
    let
        inherit (lib.my) mapHosts;
        system = "x86_64-linux";
        pkgs = nixpkgs.legacyPackages.${system};
        lib = nixpkgs.lib.extend (self: super: { my = import ./lib { inherit inputs pkgs; lib = self; }; });
    in
    {
        lib = lib.my;
        nixosConfigurations =
            mapHosts ./hosts { inherit system; };
    };
}

