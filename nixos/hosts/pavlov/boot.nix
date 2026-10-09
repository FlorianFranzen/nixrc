{ pkgs, ... }:

{
  boot = {
    # Early boot kernel modules
    initrd.availableKernelModules = [ "uhci_hcd" "ehci_pci" "ata_piix" "ahci" "firewire_ohci" "usb_storage" "sd_mod" "sr_mod" ];

    # Additional kernel modules
    kernelModules = [ "kvm-intel" "it87" ];

    # Enable ZFS support
    supportedFilesystems = [ "zfs" ];

    # Use the systemd-boot EFI boot loader.
    loader.systemd-boot.enable = true;
  };
}
