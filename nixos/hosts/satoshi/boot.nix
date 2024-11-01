{ pkgs, ... }:

{
  boot = {
    # EFI boot variables are safe to be modified
    loader.efi.canTouchEfiVariables = true;

    # Install signed bootloader to efi mirror
    lanzaboote.extraEfiSysMountPoints = [ "/boot-mirror" ];

    # Recent and patched kernel for full hardware support
    kernelPackages = pkgs.linuxPackages_amd;

    # Additional modules to load
    kernelModules = [ "kvm-amd" ];

    # Use patched ideapad-laptop
    extraModulePackages = [ pkgs.linuxPackages_amd.ideapad-laptop ];

    # Additional modules to provide in stage 1
    initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "uas" "sd_mod" ];

    kernelParams = [
      # Fix backlight control
      "amdgpu.backlight=0"
      # Enable kernel rfkill hack
      "ideapad-laptop.no_rfkill=1"
    ];

    # Avoid touchpad race condition
    extraModprobeConfig = ''
      softdep i2c_hid pre: pinctrl_amd
      softdep usbhid pre: pinctrl_amd
    '';

    # Add additional filesystem support
    supportedFilesystems = [ "ntfs" "zfs" ];

    # Use unstable zfs to support newer kernels
    zfs.package = pkgs.zfs_unstable;
  };
}
