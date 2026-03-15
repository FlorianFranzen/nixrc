{ ... }: 

{
  # Root filesystem, boot and swap on NVME
  fileSystems = {
    "/boot" = {
      device = "/dev/disk/by-uuid/A11E-17EB";
      fsType = "vfat";
    };

    "/" = {
      device = "/dev/disk/by-uuid/d439c801-650c-4e46-898e-ffeb99e96239";
      fsType = "btrfs";
      options = [ "subvol=@" "compress=zstd" "noatime" ];
    };

    "/home" = {
      device = "/dev/disk/by-uuid/d439c801-650c-4e46-898e-ffeb99e96239";
      fsType = "btrfs";
      options = [ "subvol=@home" "compress=zstd" ];
    };

    "/nix" = {
      device = "/dev/disk/by-uuid/d439c801-650c-4e46-898e-ffeb99e96239";
      fsType = "btrfs";
      options = [ "subvol=@nix" "compress=zstd" "noatime" ];
    };

    "/var/lib/teddycloud" = {
      device = "/dev/disk/by-uuid/d439c801-650c-4e46-898e-ffeb99e96239";
      fsType = "btrfs";
      options = [ "subvol=@teddycloud" "compress=zstd" "noatime" ];
    };
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/3c142f56-6f1a-4a75-b68c-4e0230606621"; }
  ];
}
