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
          "/tardis/data" = {
            subvolume = {
              "@backups" = { };
              "@cloud" = { };
              "@roms" = { };
              "@videos" = { };
            };
            target = "/tardis/external/fawkes";
          };
        };
      };
    };
  };

  services.btrbk.sshAccess = [
    {
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBTdvxKKQnoCUpsvBfUWYHDwA2tMpFj3zwT2s3kfuWWO mind-the-gap";
      roles = [ "info" "target" "delete" ];
      extraArgs = [ "--log" "--restrict-path" "/tardis/external/lovelace" ];
    }
  ];
}
