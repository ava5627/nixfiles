{
  config,
  lib,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.services.cloudflare_tunnel;
in {
  options.modules.services.cloudflare_tunnel.enable = mkEnableOption "Enable Cloudflare Tunnel service";
  config = mkIf cfg.enable {
    services.cloudflared = {
      enable = true;
      tunnels = {
        "f610fc51-1c8d-4d5f-aa98-e1a56a45da56" = {
          credentialsFile = "/home/ava/.cloudflared/cert.pem";
          default = "http_status:404";
          ingress = {
            "foundry.byteranger.dev" = "http://localhost:30000";
            "nightscout.byteranger.dev" = "http://localhost:1337";
          };
        };
      };
    };
  };
}
