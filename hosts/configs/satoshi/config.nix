{ config, pkgs, lib, profiles, homes, ... }:

{
  imports =
    (with profiles; [ corp docker gaming laptop media mail office ]) ++
    (with profiles.develop; [ minimal extra cross linux manufac cad net ]) ++
    (with profiles.desktops; [ gdm sway ]) ++
    (with profiles.networks; [ iwd ]) ++
    (with profiles.hardware; [
      secure-boot
      common-cpu-amd
      common-cpu-amd-pstate
      common-gpu-amd
      common-pc-laptop
      common-pc-ssd
      android
      pipewire
      smartcard
      wooting
      zsa
    ]);

  # EFI boot variables are safe to be modified
  boot.loader.efi.canTouchEfiVariables = true;

  # Install signed bootloader to efi mirror
  boot.lanzaboote.extraEfiSysMountPoints = [ "/boot-mirror" ];

  # Add some fancontrol 
  services.thermald.enable = true;

  # Install full desktop environment
  home-manager.users.florian = homes.desktop-solarized;

  # Disable GPU unless overriden in specialization
  hardware.nvidiaOptimus.disable = lib.mkDefault true;

  boot = {
    # Recent and patched kernel for full hardware support
    kernelPackages = pkgs.linuxPackages_amd;

    # Use patched ideapad-laptop
    extraModulePackages = [ pkgs.linuxPackages_amd.ideapad-laptop ];

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

  # Support printing on home printer
  services.printing = {
    enable = true;
    drivers = [ pkgs.cups-brother-mfcl2710dw ];
  };

  # Support scanning on home printer
  hardware.sane = {
    enable = true;
    brscan4 = {
      enable = true;
      netDevices.gutenberg = {
        nodename = "gutenberg.fritz.box";
        model = "MFC-L2710DW";
      };
    };
  };

  # Give default user scanner access
  users.extraUsers.florian.extraGroups = [ "scanner" ];

  # Use AMD CPU compatible bumblebee
  nixpkgs.overlays = [
    (self: super: { bumblebee = super.bumblebee_amd; })
  ];

  # Set processor architecture
  nixpkgs.hostPlatform = "x86_64-linux";

  # Set current state version
  system.stateVersion = "23.05";
}
