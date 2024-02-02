{ config, pkgs, lib, profiles, homes, ... }:

{
  boot = {
    # Use current kernel for better compatibility
    kernelPackages = pkgs.linuxPackages_6_6;

    # Blacklist false detections
    blacklistedKernelModules = [ "asus_nb_wmi" "eeepc_wmi" ];

    # Support cpu and mainboard sensors
    kernelModules = [ "kvm-amd" "nct6775" ];

    # Support some additional filesystems
    supportedFilesystems = [ "ntfs" "zfs" ];

    # Some additional modules to get us through stage one
    initrd.availableKernelModules = [ "nvme" "thunderbolt" "xhci_pci" "ahci" "usbhid" "sd_mod" ];
  };
}
