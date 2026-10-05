{
  config,
  lib,
  inputs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.sops;
in {
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  options.modules.sops.enable = mkBool true "sops secret management";
  config = mkIf cfg.enable {
    sops = {
      defaultSopsFile = secrets/secrets.yaml;
      defaultSopsFormat = "yaml";
      age.keyFile = "/home/${config.user.name}/.config/sops/age/keys.txt";
      secrets = {
        "cloudflare/tunnels/tachi" = {
          owner = config.user.name;
          group = config.user.group;
          mode = "0400";
        };
      };
    };
  };
}
