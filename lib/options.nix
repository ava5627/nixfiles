{ lib, ... }:
let
    inherit (lib) mkOption;
in
{
    mkOpt = type: default: mkOption { inherit type default; };
    mkOpt' = type: default: description: mkOption { inherit type default description; };
    mkBool = default: description: mkOption { type = lib.types.bool; inherit default description; };
}
