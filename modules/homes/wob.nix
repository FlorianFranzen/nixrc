{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.wob;
in {
  options.services.wob = {
    enable = mkEnableOption "wayland overlay bar";

    extraArgs = mkOption {
      type = with types; listOf str;
      default = [ ];
      description = "Extra arguments to pass to wob.";
    };
  };

  config = mkIf cfg.enable {
    systemd.user = {
      services.wob = {
        Unit = {
          Description = "A lightweight overlay bar for Wayland";
          Documentation = [ "man:wob(1)" ];

          ConditionEnvironment = "WAYLAND_DISPLAY";
        };

        Service = {
          StandardInput = "socket";
          ExecStart = "${pkgs.wob}/bin/wob ${escapeShellArgs cfg.extraArgs}";
        };
      };

      sockets.wob = {
       Socket = {
         ListenFIFO = "%t/wob.sock";
         SocketMode = "0600";
        };
      };
    };
  };
}
