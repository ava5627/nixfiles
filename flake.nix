{
    description = "NixOS configuration";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        home-manager.url = "github:nix-community/home-manager";
        home-manager.inputs.nixpkgs.follows = "nixpkgs";
        nix-gc-env.url = "github:Julow/nix-gc-env";

        nixos-hardware.url = "github:NixOS/nixos-hardware";
    };

    outputs = inputs@{ self, nixpkgs, ... }:
    let
        inherit (lib.my) mapHosts;
        system = "x86_64-linux";
        # mkPkgs = p: overlay: import p {
        #     inherit system;
        #     config.allowUnfree = true;
        #     overlays = overlay;
        # };
        pkgs = nixpkgs.legacyPackages.${system};
        lib = nixpkgs.lib.extend (self: super: { my = import ./lib { inherit inputs pkgs; lib = self; }; });
    in
    {
        lib = lib.my;

        nixosConfigurations =
            mapHosts ./hosts { inherit system; };

    };
}

