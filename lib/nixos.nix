{ inputs, lib, pkgs, ... }:
with lib;
with lib.my;
{
    mkHost = path: attrs @ { system, ... }:
        nixosSystem {
            inherit system;
            specialArgs = { inherit lib inputs system; };
            modules = [
                {
                    nixpkgs.pkgs = pkgs;
                    networking.hostName = mkDefault (removeSuffix ".nix" (basename path));
                }
                (filterAttrs (n: v: !elem n [ "system" ]) attrs)
                ../.
                (import path)
            ];
        };
    mapHosts = dir: attrs: importModules dir (hostPath: mkHost hostPath attrs);
}
