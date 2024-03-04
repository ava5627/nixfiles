{ inputs, lib, ... }:
with lib;
with lib.my;
{
    mkHost = path: attrs @ { system, ... }:
        nixosSystem {
            inherit system;
            specialArgs = { inherit lib inputs system; };
            modules = [
                {
                    networking.hostName = mkDefault (removeSuffix ".nix" (baseNameOf path));
                }
                (filterAttrs (n: v: !elem n [ "system" ]) attrs)
                ../.
                (import path)
            ];
        };
    mapHosts = dir: attrs: mapModules dir (hostPath: mkHost hostPath attrs);
}
