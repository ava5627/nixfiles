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
      llvmPackages.bintools
      cargo-nextest
      vscode-extensions.vadimcn.vscode-lldb.adapter
    ];

    environment.variables = {
      RUSTUP_HOME = "$XDG_DATA_HOME/rustup";
      CARGO_HOME = "$XDG_DATA_HOME/cargo";
    }; # get cargo and rustup out of home
  };
}
