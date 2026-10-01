{
  config,
  lib,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.cloudflare_tunnel;
in {
  options.modules.cloudflare_tunnel.enable = mkEnableOption "Enable Cloudflare Tunnel service";
  config = mkIf cfg.enable {
    services.cloudflared = {
      enable = true;
      tunnels = {
        "f610fc51-1c8d-4d5f-aa98-e1a56a45da56" = {
          credentialsFile = "/home/ava/.cloudflared/cert.pem";
        };
      };
    };
  };
}
