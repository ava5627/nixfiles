{ lib, ...}:
let
    inherit (builtins) readDir pathExists concatLists;
    inherit (lib) nameValuePair removeSuffix mapAttrsToList filterAttrs id attrValues hasSuffix;
    inherit (import ./attrs.nix { inherit lib; }) mapFilterAttrs;
in
rec {
    mapModules = dir: fn:
        mapFilterAttrs
            (n: v: v != null)
            (name: value:
                let path = "${toString dir}/${name}"; in
                if value == "directory" && pathExists "${path}/default.nix"
                then nameValuePair name (fn path)
                else if value == "regular" && name != "default.nix" && hasSuffix ".nix" name
                then nameValuePair (removeSuffix ".nix" name) (fn path)
                else nameValuePair "" null)
            (readDir dir);

    mapModulesRec = dir: fn:
        mapFilterAttrs
            (n: v: v != null)
            (name: value:
                let path = "${toString dir}/${name}"; in
                if value == "directory" && pathExists "${path}/default.nix"
                then nameValuePair name (fn path)
                else if value == "directory"
                then nameValuePair name (mapModulesRec path fn)
                else if value == "regular" && name != "default.nix"
                then nameValuePair (removeSuffix ".nix" name) (fn path)
                else nameValuePair "" null)
            (readDir dir);

    mapModulesRec' = dir: fn:
        let
            dirs = mapAttrsToList
                (n: v: "${dir}/${n}")
                (filterAttrs
                    (n: v: v == "directory")
                    (readDir dir));
            files = attrValues (mapModules dir id);
            paths = files ++ concatLists (map (d: mapModulesRec' d id) dirs);
        in map fn paths;
}
