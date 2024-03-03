{ lib, ...}:
let
    inherit (builtins) readDir pathExists;
    inherit (lib) nameValuePair removeSuffix;
    inherit (import ./attrs.nix { inherit lib; }) mapFilterAttrs;
in
{
    importModules = dir: fn:
        mapFilterAttrs
            (n: v: v != null)
            (name: value:
                let path = "${toString dir}/${name}"; in
                if value == "directory" && pathExists "${path}/default.nix"
                then nameValuePair name (fn path)
                else if value == "regular" && name != "default.nix"
                then nameValuePair (removeSuffix ".nix" name) (fn path)
                else nameValuePair "" null)
            (readDir dir);
}
