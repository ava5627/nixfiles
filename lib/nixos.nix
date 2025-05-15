{
  inputs,
  lib,
  ...
}:
with lib;
with lib.my; {
  mkHost = path: {
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
        ../.
        (import path)
      ];
    };
  mapHosts = dir: attrs: mapModules dir (hostPath: mkHost hostPath attrs);
}
