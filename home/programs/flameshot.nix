{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.programs.flameshot;
  iniFormat = pkgs.formats.ini {};
  iniFile = iniFormat.generate "flameshot.ini" cfg.settings;
in {
  meta.maintainers = [maintainers.hamhut1066];

  options.programs.flameshot = {
    enable = mkBool true "Flameshot";
    settings = mkOption {
      type = iniFormat.type;
      default = {};
      description = ''Configuration to use for Flameshot. See <https://github.com/flameshot-org/flameshot/blob/master/flameshot.example.ini> for available options. '';
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      (lib.hm.assertions.assertPlatform "services.flameshot" pkgs
        lib.platforms.linux)
    ];

    home.packages = [pkgs.flameshot];

    xdg.configFile = mkIf (cfg.settings != {}) {
      "flameshot/flameshot.ini".source = iniFile;
    };
  };
}
