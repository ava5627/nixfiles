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
        vaapiVdpau
      ];
    };
    hardware.nvidia.modesetting.enable = true;
    hardware.nvidia.open = lib.mkDefault true;
    services.xserver.videoDrivers = ["nvidia"];
    environment.systemPackages = with pkgs; [
      (writeShellScriptBin "nvidia-settings" ''
        mkdir -p "$XDG_CONFIG_HOME/nvidia"
        exec ${config.boot.kernelPackages.nvidia_x11.settings}/bin/nvidia-settings --config="$XDG_CONFIG_HOME/nvidia/settings"
      '')
    ]; # make nvidia-settings not use home directory
  };
}
