{
  pkgs,
  config,
  ...
}: {
  config = {
    systemd.services.logiops = {
      description = "Logitech Configuration Daemon";
      documentation = ["https://github.com/PixlOne/logiops"];

      wantedBy = ["multi-user.target"];

      startLimitIntervalSec = 0;
      after = ["multi-user.target"];
      wants = ["multi-user.target"];
      serviceConfig = {
        ExecStart = "${pkgs.logiops}/bin/logid";
        Restart = "always";
        User = "root";

        RuntimeDirectory = "logiops";

        CapabilityBoundingSet = ["CAP_SYS_NICE"];
        DeviceAllow = ["/dev/uinput rw" "char-hidraw rw"];
        ProtectClock = true;
        PrivateNetwork = true;
        ProtectHome = true;
        ProtectHostname = true;
        PrivateUsers = true;
        PrivateMounts = true;
        PrivateTmp = true;
        RestrictNamespaces = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectControlGroups = true;
        MemoryDenyWriteExecute = true;
        RestrictRealtime = true;
        LockPersonality = true;
        ProtectProc = "invisible";
        SystemCallFilter = ["nice" "@system-service" "~@privileged"];
        RestrictAddressFamilies = ["AF_NETLINK" "AF_UNIX"];
        RestrictSUIDSGID = true;
        NoNewPrivileges = true;
        ProtectSystem = "strict";
        ProcSubset = "pid";
        UMask = "0077";
      };
    };
    environment.etc."logid.cfg".source = "${config.dotfiles.config}/logid.cfg";

    # Add a `udev` rule to restart `logiops` when the mouse is connected
    # https://github.com/PixlOne/logiops/issues/239#issuecomment-1044122412
    services.udev.extraRules = ''
      ACTION=="add", SUBSYSTEM=="input", ATTRS{id/vendor}=="046d", RUN{program}="${config.systemd.package}/bin/systemctl --no-block try-restart logiops.service"
    '';
  };
}
