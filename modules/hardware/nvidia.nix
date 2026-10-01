{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.hardware.nvidia;
in {
  options.modules.hardware.nvidia = {
    enable = mkBool false "nvidia";
  };

  config = mkIf cfg.enable {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
       libva-vdpau-driver
      ];
    };
    hardware.nvidia.modesetting.enable = true;
    hardware.nvidia.open = lib.mkDefault true;
    services.xserver.videoDrivers = ["nvidia"];
  };
}
