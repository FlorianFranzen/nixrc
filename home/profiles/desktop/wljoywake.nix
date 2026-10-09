{ pkgs, ... }:

{
  systemd.user.services.wljoywake = {
    Unit = {
      Description = "Wayland idle inhibit on joystick input";
      After = [ "swayidle.service" ];
      PartOf = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart = "${pkgs.wljoywake}/bin/wljoywake";
      Restart = "always";
    };

    Install.WantedBy = [ "graphical-session.target" ];
  };
}
