{
  inputs,
  lib,
  ...
}:
with lib;
with lib.my; {
  mkHost = path: attrs @ {
    system,
    username,
    ...
  }:
    nixosSystem {
      inherit system;
      specialArgs = {inherit lib inputs system username;};
      modules = [
        {
          networking.hostName = mkDefault (baseNameOf path);
        }
        (filterAttrs (n: v: !elem n ["username" "system"]) attrs)
        ../.
        (import path)
      ];
    };
  mapHosts = dir: attrs: mapModules dir (hostPath: mkHost hostPath attrs);
}
