{ config, pkgs, lib, profiles, ... }:

{
  imports = with profiles; [
    laptop desktops.sway develop.manufac networks.iwd hardware.pulseaudio hardware.smartcard services.octoprint
  ];

  # Do not use home-manager on this host
  home-manager.users.florian = {};

  boot = {
    # Hybrid 32bit UEFI but 64bit Atom CPU	
    loader.grub = {
      enable = true;
      efiSupport = true;
      device = "nodev";
      forcei686 = true;
    };

    # Full hardware support requires recent kernel
    kernelPackages = pkgs.linuxPackages_6_1;

    # Fix for freezing (TODO might be fixed in recent kernel or require patch)
    kernelParams = [
      "intel_idle.max_cstate=1"
    ];

    # Add necessary modules for internal keyboard support during early boot
    initrd.availableKernelModules = [
      "hid_asus"
      "i2c_designware_platform"
      "i2c_hid"
      "i2c_hid_acpi"
    ];

    # Fix for quirky sdio sound card
    extraModprobeConfig = ''
      options snd_soc_rt5645 quirk=0x31
    '';
  };

  # Needed for intel sst and wifi
  hardware.firmware = [ pkgs.firmwareLinuxNonfree ];

  # Fix trackpad on resume
  powerManagement.resumeCommands = ''
    rmmod elan_i2c
    modprobe elan_i2c
  '';

  # Add some software
  environment.systemPackages = with pkgs; [
    libreoffice
  ];

  # Compile kernel with opregion support
  nixpkgs.config.packageOverrides = pkgs: pkgs.lib.recursiveUpdate pkgs {
    linuxKernel.kernels.linux_6_1 = pkgs.linuxKernel.kernels.linux_6_1.override {
      structuredExtraConfig = with lib.kernel; {
        I2C = yes;
        "ACPI_I2C_OPREGION" = yes;
      };
    };
  };

  # Set processor architecture
  nixpkgs.hostPlatform = "x86_64-linux";

  # Current state version
  system.stateVersion = "22.11";
}

