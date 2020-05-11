# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, ... }:

{
  imports = [ 
    <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
  ];

  boot.initrd.availableKernelModules = [ "uhci_hcd" "ehci_pci" "ahci" "firewire_ohci" "usbhid" "usb_storage" "sd_mod" "sdhci_pci" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" "wl" "xpad" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];


  # Primary drive - SSD 256GB

  ## efi: FAT32 partition for UEFI booting
  fileSystems."/boot" 	= { 
    device = "/dev/disk/by-uuid/67E3-17ED";
    fsType = "vfat";
  };

  ## system: encrypted main btrfs partition
  boot.initrd.luks.devices."system".device = "/dev/disk/by-uuid/95095698-2bd3-4e96-91a1-7a4e327a3412";

  fileSystems."/" = { 
    device = "/dev/disk/by-uuid/79e6a8d4-a32a-41e9-a0e1-a15e18e32b02";
    fsType = "btrfs";
    options = [ "subvol=@" "compress=zstd" ];
  };

  fileSystems."/home" = { 
    device = "/dev/disk/by-uuid/79e6a8d4-a32a-41e9-a0e1-a15e18e32b02";
    fsType = "btrfs";
    options = [ "subvol=@home" "compress=zstd" ];
  };

  fileSystems."/tardis/system" = { 
    device = "/dev/disk/by-uuid/79e6a8d4-a32a-41e9-a0e1-a15e18e32b02";
    fsType = "btrfs";
    options = [ "noatime" ];
  };

  ## swap: swap partition
  swapDevices = [
    { device = "/dev/disk/by-uuid/406c960c-0f18-40e9-a510-8891632f7069"; }
  ];


  # Secondary drive - HDD 1TB

  ## data: main encrypted btrfs data partition
  boot.initrd.luks.devices."data".device = "/dev/disk/by-uuid/2b373cc4-b551-4291-81bc-1327e28f3184";

  fileSystems."/tardis/data" = { 
    device = "/dev/disk/by-uuid/351fae51-949f-4af1-9fbc-318b6fcf4f53";
    fsType = "btrfs";
    options = [ "noatime" ];
  };

  fileSystems."/home/florian/Cloud" = { 
    device = "/dev/disk/by-uuid/351fae51-949f-4af1-9fbc-318b6fcf4f53";
    fsType = "btrfs";
    options = [ "subvol=@cloud" "compress=zstd" ];
  };

  # CPU settings
  nix.maxJobs = lib.mkDefault 8;
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
}
