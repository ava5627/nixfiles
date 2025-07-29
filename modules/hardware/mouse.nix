{
  pkgs,
  config,
  ...
}: {
  config = {
    # Stolen from https://github.com/kylechui/dotfiles/blob/nix-os/nixos/logiops.nix
    systemd.services.logiops = {
      description = "Logitech Configuration Daemon";
      documentation = ["https://github.com/PixlOne/logiops"];
      wantedBy = ["graphical.target"];
      startLimitIntervalSec = 0;
      after = ["graphical.target"];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.logiops}/bin/logid";
        User = "root";
      };
    };
    environment.etc."logid.cfg".text = builtins.readFile "${config.dotfiles.config}/logid.cfg";
    environment.systemPackages = with pkgs; [logiops usbutils];
    modules.autoStart = [
      "solaar -w hide"
    ];
    hardware.logitech.wireless = {
      enable = true;
      enableGraphical = true;
    };
    home.home.shellAliases = {
      logirestart = "sudo systemctl restart logiops";
    };

    # Add a `udev` rule to restart `logiops` when the mouse is connected
    # https://github.com/PixlOne/logiops/issues/239#issuecomment-1044122412
    services.udev.extraRules = ''
      ACTION=="change", SUBSYSTEM=="power_supply", ATTRS{manufacturer}=="Logitech", RUN{program}="${config.systemd.package}/bin/systemctl --no-block try-restart logiops.service"
    '';
  };
}
