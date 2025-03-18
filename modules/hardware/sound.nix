{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.hardware.sound;
in {
  options.modules.hardware.sound = {
    enable = mkBool true "Sound";
  };
  config = mkIf cfg.enable {
    services.pipewire = {
      enable = true;
      wireplumber.enable = true;
      pulse.enable = true;
      alsa.enable = true;
      extraConfig.pipewire."92-low-latency" = {
        context.properties = {
          default.clock.rate = 48000;
          default.clock.quantum = 32;
          default.clock.min-quantum = 32;
          default.clock.max-quantum = 32;
        };
      };
    };
    environment.systemPackages = with pkgs; [
      pavucontrol # PulseAudio Volume Control
      qpwgraph # pipewire graph interface
      playerctl # media player control
    ];
    home.services.playerctld.enable = true;
  };
}
