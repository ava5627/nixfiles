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
        "4a3abcc9-9d9f-4a95-82b8-a19095633889" = {
          credentialsFile = "${config.sops.secrets."cloudflare/tunnels/tachi".path}";
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
