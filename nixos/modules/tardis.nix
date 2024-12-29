{ config, pkgs, lib, ... }:

let 
  cfg = config.services.tardis;

  hostName = config.networking.hostName;
in {
  options.services.tardis = {
    enable = lib.mkEnableOption "Tardis snapshot and backup service";

    device = lib.mkOption {
      type = lib.types.str;
    };

    mount = lib.mkOption {
      type = lib.types.str;
      default = "/tardis/system";
    };

    subvolumes = lib.mkOption {
      type = with lib.types; listOf str;
      default = [ "@home" ];
    };
  };

  config = lib.mkIf cfg.enable {
    # Btrfs root mount point used by btrbk
    fileSystems.${cfg.mount} = {
      device = cfg.device;
      fsType = "btrfs";
      options = [ "compress=zstd" "noatime" ];
    };

    # Daily snapshot service wit environment.systemPackages = with pkgs;h optional external backup
    services.btrbk.instances.tardis-daily = {
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
          ${cfg.mount} = {
            subvolume = lib.genAttrs cfg.subvolumes (_: {});
            target = "/tardis/external/${hostName}";
          };
        };
      };
    };

    environment.systemPackages = [
      (pkgs.writeShellScriptBin "tardis-setup" ''
        exec mkdir -p ${cfg.mount}/snapshots
      '')
    ];
  };
}
