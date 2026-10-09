{
  boot = {
    # Autodetect during nixos install
    initrd.availableKernelModules = [ "nvme" "xhci_pci" "thunderbolt" "usb_storage" "usbhid" "sd_mod" ];
    kernelModules = [ "kvm-amd" ];

    # EFI boot variables are safe to be modified
    loader.efi.canTouchEfiVariables = true;

    # Install signed bootloader to efi mirror
    lanzaboote.extraEfiSysMountPoints = [ "/boot-mirror" ];
  };
}
