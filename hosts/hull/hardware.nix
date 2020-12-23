# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, ... }:

{
  boot.initrd.availableKernelModules = [ "xhci_pci" "usb_storage" "sd_mod" "sdhci_acpi" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/9b42b201-27d1-43c2-a234-ac13e17d0c2c";
      fsType = "btrfs";
      options = [ "subvol=@nixos" "compress=zstd" ];
    };

  boot.initrd.luks.devices."system".device = "/dev/disk/by-uuid/3c3ffd5c-c0ba-460f-92ee-2621cc12fc50";

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/9b42b201-27d1-43c2-a234-ac13e17d0c2c";
      fsType = "btrfs";
      options = [ "subvol=@home" "compress=zstd" ];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/3A22-4D69";
      fsType = "vfat";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/84d7d83e-326a-4ab4-b7a4-a74b3ccce2e3"; }
    ];

  nix.maxJobs = lib.mkDefault 4;
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
}
