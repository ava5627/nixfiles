{lib, ...}: let
  inherit (lib) filterAttrs mapAttrs';
in {
  # Use maping function to alter set then filter based on predicate
  mapFilterAttrs = pred: fn: attrs: filterAttrs pred (mapAttrs' fn attrs);
}
