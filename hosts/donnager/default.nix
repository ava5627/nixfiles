{ ... }:
{
    imports = [
        ./hardware-configuration.nix
    ];
    modules.theme.active = "Tokyo Night";
    modules.hardware.nvidia.enable = true;
    hardware.nvidia.forceFullCompositionPipeline = true;
    boot.loader.systemd-boot.enable = true;

    services.xserver = {
        monitorSection = ''
            VendorName     "Unknown"
            ModelName      "DELL E2422H"
            HorizSync       30.0 - 83.0
            VertRefresh     50.0 - 75.0
            Option         "DPMS"
        '';
        screenSection = ''
            Option "metamodes" "DP-0: nvidia-auto-select +3840+0 {ForceCompositionPipeline=On, ForceFullCompositionPipeline=On}, DP-4: nvidia-auto-select +1920+0 {ForceCompositionPipeline=On, ForceFullCompositionPipeline=On}, DP-2: nvidia-auto-select +0+0 {ForceCompositionPipeline=On, ForceFullCompositionPipeline=On};
            Option "MultiGPU" "Off"
            Option "BaseMosaic" "off"
            Option "Stereo" "0"
            Option "nvidiaXineramaInfoOrder" "DFP-5"
        '';
    };

}
