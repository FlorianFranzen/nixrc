{ pkgs, ... }:

{
  environment.systemPackages = [
    pkgs.btrbk
  ];

  environment.etc."btrbk.conf".text = ''
    timestamp_format      long

    snapshot_preserve_min  7d
    snapshot_preserve     14d

    target_preserve_min   no
    target_preserve       14d 8w 6m *y

    archive_preserve_min  latest
    archive_exclude       @

    snapshot_dir          snapshots

    volume /tardis/system
      subvolume @home
        target /tardis/data/backups
      subvolume @
        snapshot_preserve_min all
        snapshot_preserve no
        noauto yes
  '';

  systemd = {
    services.btrbk = {
      description = "btrbk snapshot and backup service";
      requires = [ "local-fs.target" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.btrbk}/bin/btrbk run";
      };
    };

    timers.btrbk = {
      description = "Run btrbk service on a regular basis";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "daily";
        Persistent = true;
      };
    };
  };
}
