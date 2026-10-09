{
  # Decrypt system mirror at boot
  boot.initrd.luks.devices."system-one".device = "/dev/disk/by-uuid/5b2fb1c3-6488-43dc-b134-595fad3685de";
  boot.initrd.luks.devices."system-two".device = "/dev/disk/by-uuid/f350fb16-2f85-4f22-9cba-1213169995af";

  # Main filesystem subvolumes
  fileSystems."/" =
    { device = "/dev/mapper/system-one";
      fsType = "btrfs";
      options = [ "subvol=@" "compress=zstd" "noatime" ];
    };

  fileSystems."/home" =
    { device = "/dev/mapper/system-one";
      fsType = "btrfs";
      options = [ "subvol=@home" "compress=zstd" ];
    };

  fileSystems."/nix" =
    { device = "/dev/mapper/system-one";
      fsType = "btrfs";
      options = [ "subvol=@nix" "compress=zstd" "noatime" ];
    };

  # Additional subvolumes in home folder
  fileSystems."/home/florian/ROMs" =
    { device = "/dev/mapper/system-one";
      fsType = "btrfs";
      options = [ "subvol=@roms" "compress=zstd" "noatime" ];
    };

  fileSystems."/home/florian/.local/share/Steam" =
    { device = "/dev/mapper/system-one";
      fsType = "btrfs";
      options = [ "subvol=@steam" "compress=zstd" "noatime" ];
    };

  # Mirrored UEFI partitions
  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/307B-9234";
      fsType = "vfat";
    };

  fileSystems."/boot-mirror" =
    { device = "/dev/disk/by-uuid/30B5-0E4E";
      fsType = "vfat";
    };

  # System mirror root mounting point used by btrbk
  fileSystems."/tardis/system" =
    { device = "/dev/mapper/system-one";
      fsType = "btrfs";
      options = [ "compress=zstd" "noatime" ];
    };

  # Regurlary scrub btrfs mirror
  services.btrfs.autoScrub = {
    enable = true;
    fileSystems = [ "/tardis/system" ];
  };
}
