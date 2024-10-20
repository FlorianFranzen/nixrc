{ pkgs, ... }:

{
  services.btrbk.instances = {
    daily = {
      onCalendar = "daily";

      settings = {
        timestamp_format = "long";
        transaction_syslog = "cron";

        snapshot_preserve_min = "7d";
        snapshot_preserve = "21d";

        target_preserve_min = "no";
        target_preserve = "14d 4w 6m *y";

        snapshot_dir = "snapshots";

        volume = {
          "/tardis/system" = {
            subvolume = {
              "@home" = {};
            };
            target = "/tardis/external/fawkes";
          };
        };
      };
    };
    weekly = {
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
              "@backups" = {};
              "@cloud" = {};
              "@roms" = {};
            };
            target = "/tardis/external/fawkes";
          };
        };
      };

    };
  };
}
