{ pkgs, ... }:

{
  systemd.user.services.wljoywake = {
    Unit = {
      Description = "Wayland idle inhibit on joystick input";
      After = [ "graphical-session-pre.target" "swayidle.service" ];
      Requires = [ "swayidle.service" ];
      BindsTo = [ "swayidle.service" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.wljoywake}/bin/wljoywake";
      Restart = "always";
    };
  };
}
