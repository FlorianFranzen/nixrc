{ config, lib, pkgs, ... }:

{
  fileSystems = {
    # Main SSD partition with various BTRFS subvolumes
    "/" = {
      device = "/dev/disk/by-uuid/730d4516-29c2-4ee2-a6a7-063dbba40a3b";
      fsType = "btrfs";
      options = [ "subvol=@" "compress=zstd" "noatime" ];
    };

    "/home" = {
      device = "/dev/disk/by-uuid/730d4516-29c2-4ee2-a6a7-063dbba40a3b";
      fsType = "btrfs";
      options = [ "subvol=@home" "compress=zstd" ];
    };

    "/nix" = {
      device = "/dev/disk/by-uuid/730d4516-29c2-4ee2-a6a7-063dbba40a3b";
      fsType = "btrfs";
      options = [ "subvol=@nix" "compress=zstd" "noatime" ];
    };

    # Data HDD mirror with additional BTRFS subvolumes
    "/data" = {
      device = "/dev/disk/by-uuid/aa222bd4-8f66-47cb-9abf-53004b68cbba";
      fsType = "btrfs";
      options = [ "subvol=@data" "compress=zstd" "noatime" ];
    };

    # EFI Boot Partition (ESP)
    "/boot" = {
      device = "/dev/disk/by-uuid/8CB9-8FD9";
      fsType = "vfat";
    };
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/4fc7b43b-d553-4ddb-bb41-b0a25d308f83"; }
  ];
}
