{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.dev.rust;
in {
  options.modules.dev.rust.enable = mkBool true "Rust";
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      rustup
    ];

    environment.variables = {
      RUSTUP_HOME = "$XDG_DATA_HOME/rustup";
      CARGO_HOME = "$XDG_DATA_HOME/cargo";
    };
  };
}