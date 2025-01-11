{ pkgs, ... }:

{
  services.btrbk.instances = {
    tardis-weekly = {
      onCalendar = "weekly";

      settings = {
        timestamp_format = "long";
        transaction_syslog = "cron";

        snapshot_preserve_min = "latest";
        snapshot_preserve = "8w";

        target_preserve_min = "no";
        target_preserve = "4w 6m";

        snapshot_dir = "snapshots";

        volume = {
          "/tardis/system" = {
            subvolume = {
              "@roms" = {};
            };
            target = "/tardis/external/fawkes";
          };
          "/tardis/data" = {
            subvolume = {
              "@backups" = {};
              "@cloud" = {};
            };
            target = "/tardis/external/fawkes";
          };
        };
      };
    };
  };
}
