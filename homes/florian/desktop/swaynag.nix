{ pkgs, ... }:

{
  systemd.user.services.swaynag-battery = {
    Unit = {
      Description = "Low battery notification";
      PartOf = "graphical-session.target";
    };

    Service = {
      Type = "simple";
      ExecStart = "${pkgs.swaynag-battery}/bin/swaynag-battery";
      Restart = "on-failure";
    };

    Install.WantedBy = [ "sway-session.target" ];
  };
}
