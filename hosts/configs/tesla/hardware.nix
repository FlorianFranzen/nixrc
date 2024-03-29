# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, ... }:

{
  boot.initrd.availableKernelModules = [ "uhci_hcd" "ehci_pci" "ahci" "xhci_pci" "usb_storage" "sd_mod" ];
  boot.kernelModules = [ "kvm-intel" "w83627ehf" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/010b4886-36aa-42db-b0a7-05d860fd6402";
      fsType = "btrfs";
      options = [ "subvol=@nixos" ];
    };

  fileSystems."/tmp" =
    { device = "/dev/disk/by-uuid/010b4886-36aa-42db-b0a7-05d860fd6402";
      fsType = "btrfs";
      options = [ "subvol=@tmp" ];
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/010b4886-36aa-42db-b0a7-05d860fd6402";
      fsType = "btrfs";
      options = [ "subvol=@home" ];
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/8d6e1741-bcf0-434c-b4e3-5f3853ab06ea"; }
    ];

  nix.settings.max-jobs = lib.mkDefault 4;
}
