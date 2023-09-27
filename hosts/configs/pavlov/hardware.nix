# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, ... }:

{
  boot.initrd.availableKernelModules = [ "uhci_hcd" "ehci_pci" "ata_piix" "ahci" "firewire_ohci" "usb_storage" "sd_mod" "sr_mod" ];
  boot.kernelModules = [ "kvm-intel" "it87" ];
  boot.extraModulePackages = [ ];

  # Main SSD partition with various BTRFS subvolumes
  fileSystems."/" =
    { device = "/dev/disk/by-uuid/7d69236c-bae0-4171-b06f-25f3b367510b";
      fsType = "btrfs";
      options = [ "subvol=@nixos" "compress=zstd" ];
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/7d69236c-bae0-4171-b06f-25f3b367510b";
      fsType = "btrfs";
      options = [ "subvol=@home" "compress=zstd" ];
    };

  fileSystems."/var/lib/jellyfin" =
    { device = "/dev/disk/by-uuid/7d69236c-bae0-4171-b06f-25f3b367510b";
      fsType = "btrfs";
      options = [ "subvol=@jellyfin" "compress=zstd" ];
    };

  # EFI Boot Partition (ESP)
  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/920B-CD82";
      fsType = "vfat";
    };

  # TODO: Investigate if this makes any sense
  fileSystems."/tmp" =
    { device = "/dev/disk/by-uuid/7d69236c-bae0-4171-b06f-25f3b367510b";
      fsType = "btrfs";
      options = [ "subvol=@tmp" ];
    };

  # Various ZFS media drives
  fileSystems."/media/addy" =
    { device = "data/media/addy";
      fsType = "zfs";
      options = [ "noauto" ];
    };

  fileSystems."/media/backup" =
    { device = "data/media/backup";
      fsType = "zfs";
      options = [ "noauto" ];
    };

  fileSystems."/media/music" =
    { device = "data/media/music";
      fsType = "zfs";
      options = [ "noauto" ];
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/4fc7b43b-d553-4ddb-bb41-b0a25d308f83"; }
    ];

  nix.settings.max-jobs = lib.mkDefault 4;
}