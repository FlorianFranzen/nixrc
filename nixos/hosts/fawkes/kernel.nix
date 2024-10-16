{ config, pkgs, lib, profiles, homes, ... }:

{
  boot = {
    # Use current kernel for better compatibility
    kernelPackages = pkgs.linuxPackages_ws;

    # Allow access to cpu power information
    extraModulePackages = [ pkgs.linuxPackages_ws.zenergy ];

    # Blacklist false detections
    blacklistedKernelModules = [ "asus_nb_wmi" "eeepc_wmi" ];

    # Support cpu and mainboard sensors
    kernelModules = [ "kvm-amd" "nct6775" "zenergy" ];

    # Support some additional filesystems
    supportedFilesystems = [ "ntfs" "zfs" ];

    # Support newer kernels
    zfs.package = pkgs.zfs_unstable;

    # Some additional modules to get us through stage one
    initrd.availableKernelModules = [ "nvme" "thunderbolt" "xhci_pci" "ahci" "usbhid" "sd_mod" ];
  };
}
