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
            subvolume."@home" = {};
            target = "/tardis/external/satoshi";
          };
        };
      };
    };
  };
}
