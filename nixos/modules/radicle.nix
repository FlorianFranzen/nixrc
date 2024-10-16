{ config, pkgs, lib, ... }:

let
  cfg = config.services.lnk-gitd;
in {

  options.services.lnk-gitd = {
    enable = lib.mkEnableOption "radicle link user git daemon";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.radicle-link ];

    systemd.user = {
      services.lnk-gitd = {
        enable = true;
        description = "radicle link user git daemon";
        environment = {
          RUST_LOG = "info";
        };
        script = "${pkgs.radicle-link}/bin/lnk-gitd";
        scriptArgs = "--linger-timeout 10000 --push-seeds --fetch-seeds";
      };

      sockets.lnk-gitd = {
        enable = true;
        listenStreams = [ "9987" ];
        socketConfig = {
          FileDescriptorName = "ssh";
        };
        wantedBy = [ "sockets.target" ];
      };
    };
  };
}
