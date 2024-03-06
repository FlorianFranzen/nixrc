{ pkgs, ... }:

{
  systemd.user.services.wscreensaver-bridge = {
    Unit = {
      Description = "Wayland Screensaver Bridge";
      After = [ "graphical-session-pre.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      Type = "dbus";
      BusName = "org.freedesktop.ScreenSaver";
      ExecStart = "${pkgs.wscreensaver-bridge}/bin/wscreensaver-bridge";
    };
  };
}
