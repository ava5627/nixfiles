{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.dev.nix;
in {
  options.modules.dev.nix.enable = mkBool true "Nix";
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      alejandra # nix formatter
      # nil # nix language server
      nixd
    ];
    nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
  };
}
