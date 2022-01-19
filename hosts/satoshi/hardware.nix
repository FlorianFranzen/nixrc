# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/8b8032cf-93b4-4fec-883f-28b351d82105";
      fsType = "btrfs";
      options = [ "subvol=@" "compress=zstd" "noatime" ];
    };

  boot.initrd.luks.devices."system".device = "/dev/disk/by-uuid/e83b7eb2-029c-4d3a-8faf-8e2b5269a51b";

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/8b8032cf-93b4-4fec-883f-28b351d82105";
      fsType = "btrfs";
      options = [ "subvol=@home" "compress=zstd" ];
    };

  fileSystems."/nix" =
    { device = "/dev/disk/by-uuid/8b8032cf-93b4-4fec-883f-28b351d82105";
      fsType = "btrfs";
      options = [ "subvol=@nix" "compress=zstd" "noatime"];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/76CC-245B";
      fsType = "vfat";
    };

  swapDevices = [ ];

  # high-resolution display
  hardware.video.hidpi.enable = lib.mkDefault true;
}
