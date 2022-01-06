{ pkgs, ... }:

{
  systemd.user = {
    services.wob = {
      Unit = {
        Description = "A lightweight overlay volume/backlight/progress/anything bar for Wayland";
        Documentation = [ "man:wob(1)" ];

        ConditionEnvironment = "WAYLAND_DISPLAY";
      };

      Service = {
        StandardInput = "socket";
        ExecStart = "${pkgs.wob}/bin/wob";
      };
    };

    sockets.wob = {
      Socket = {
        ListenFIFO = "%t/wob.sock";
        SocketMode = "0600";
      };
    };
  };
}
