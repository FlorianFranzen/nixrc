{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.wob;

  iniFormat = pkgs.formats.ini { };

  # TODO: Replace this once upstream supports global sections fully
  iniGenerator = lib.generators.toINIWithGlobalSection { };

  iniFile = pkgs.writeText "wob.ini" (iniGenerator {
    globalSection = cfg.settings.default or {};
    sections = removeAttrs cfg.settings [ "default" ];
  });

in {
  options.services.wob = {
    enable = mkEnableOption "wayland overlay bar";

    settings = mkOption {
      type = iniFormat.type;
      default = { };
      example = {
        default = {
      	  timeout = 1000;
          anchor = "bottom right";
        };

        "output.main".name = "DP-1";
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.user = {
      services.wob = {
        Unit = {
          Description = "A lightweight overlay bar for Wayland";
          Documentation = [ "man:wob(1)" ];

          Requires = [ "wob.socket" ];

          After = [ "graphical-session.target" ];
          PartOf = [ "graphical-session.target" ];

          ConditionEnvironment = "WAYLAND_DISPLAY";
        };

        Install.WantedBy = [ "sway-session.target" ];

        Service = {
          StandardInput = "socket";
          ExecStart = "${pkgs.wob}/bin/wob -c ${iniFile}";
        };
      };

      sockets.wob = {
        Socket = {
          ListenFIFO = "%t/wob.sock";
          SocketMode = "0600";
          RemoveOnStop = true;
          FlushPending = true;
        };
      };
    };
  };
}
