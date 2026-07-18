{
  config,
  lib,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.kanata;
in {
  options.modules.kanata.enable = mkBool true "Kanata keyboard remapping service";
  config = mkIf cfg.enable {
    users.groups.uinput = {};
    boot.kernelModules = ["uinput"];
    services.udev.extraRules = ''
      KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"
    '';
    services.kanata = {
      # service that remaps keyboards using kanata
      enable = true;
      keyboards = {
        glove80 = { # maps mouse forward to number layer and mouse back to left layer
          config = ''
            (defsrc
                q w e r
                a s d f
                x c v b
                mfwd mbck
            )

            (defalias
                mnum (tap-hold 200 200 mfwd (layer-toggle num))
                mblf (tap-hold 200 200 mbck (layer-toggle left))
            )
            (deflayer default
                q w e r
                a s d f
                x c v b
                @mnum @mblf
            )
            (deflayer num
                7 8 9 /
                4 5 6 -
                1 2 3 S-8
                _ _
            )
            (deflayer left
                o i u y
                l k j h
                _ m n p
                _ _
            )
          '';
        };
      };
    };
  };
}
