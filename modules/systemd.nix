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
}
