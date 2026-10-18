{ pkgs, ... }:

{
  systemd.user.services.wscreensaver-bridge = {
    Unit = {
      Description = "Wayland Screensaver Bridge";
      After = [ "swayidle.service" ];
      PartOf = [ "graphical-session.target" ];
    };

    Service = {
      Type = "dbus";
      BusName = "org.freedesktop.ScreenSaver";
      ExecStart = "${pkgs.wscreensaver-bridge}/bin/wscreensaver-bridge";
    };

    Install.WantedBy = [ "graphical-session.target" ];
  };
}
