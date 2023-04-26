{ pkgs, config, ... }:

{
  systemd.user.services.swaynag-battery = {
    Unit = {
      Description = "Low battery notification";
      PartOf = "graphical-session.target";
    };

    Service = {
      Environment = "PATH=${config.wayland.windowManager.sway.package}/bin";
      Type = "simple";
      ExecStart = "${pkgs.swaynag-battery}/bin/swaynag-battery";
      Restart = "on-failure";
    };

    Install.WantedBy = [ "sway-session.target" ];
  };
}
