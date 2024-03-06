{ pkgs, ...}:
{
    systemd.services =
    {
        polkit-gnome-authentication-agent-1 = {
            description = "PolicyKit Authentication Agent";
            wantedBy = [ "graphical-session.target" ];
            wants = [ "graphical-session.target" ];
            after = [ "graphical-session.target" ];
            serviceConfig = {
                Type = "simple";
                ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
                Restart = "on-failure";
                RestartSec = 1;
                TimeoutStopSec = 10;
            };
        };
        logid = {
            description = "Logid";
            serviceConfig = {
                Type = "simple";
                ExecStart = "${pkgs.logiops}/bin/logid";
            };
        };
    };
    systemd.user.services = {
        copyq = {
            description = "CopyQ clipboard management daemon";
            partOf = [ "graphical-session.target" ];
            after = [ "graphical-session.target" ];
            serviceConfig = {
                ExecStart = "${pkgs.copyq}/bin/copyq";
                Restart = "on-failure";
            };
            wantedBy = [ "graphical-session.target" ];
        };
    };
}
