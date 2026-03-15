{ pkgs, ... }:

{
  boot = {
    # Early boot kernel modules
    initrd.availableKernelModules = [ "uhci_hcd" "ehci_pci" "ata_piix" "ahci" "firewire_ohci" "usb_storage" "sd_mod" "sr_mod" ];

    # Install driver to support CX ADC cards
    extraModulePackages = [ pkgs.linuxPackages.cxadc ];

    # Additional kernel modules
    kernelModules = [ "kvm-intel" "it87" "cxadc" ];

    # Enable ZFS support
    supportedFilesystems = [ "zfs" ];

    # Use the systemd-boot EFI boot loader.
    loader.systemd-boot.enable = true;
  };
}
