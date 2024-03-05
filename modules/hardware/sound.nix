{ config, lib, ... }:
with lib;
with lib.my;
let cfg = config.modules.hardware.sound;
in
{
    options.modules.hardware.sound = {
        enable = mkBool true "Sound";
    };
    config = mkIf cfg.enable {
        sound.enable = true;
        services.pipewire = {
            enable = true;
            wireplumber.enable = true;
            pulse.enable = true;
            alsa.enable = true;
        };
    };
}
