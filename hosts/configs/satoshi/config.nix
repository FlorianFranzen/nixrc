{ config, pkgs, lib, profiles, homes, ... }:

{
  imports =
    (with profiles; [ corp docker gaming laptop media mail office ]) ++
    (with profiles.develop; [ minimal extra cross linux ]) ++
    (with profiles.desktops; [ gdm sway ]) ++
    (with profiles.networks; [ iwd ]) ++
    (with profiles.hardware; [
      #secure-boot #FIXME: Add support for mirrored boot
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
  };

  # Support printing on home printer
  services.printing = {
    enable = true;
    drivers = [ pkgs.cups-brother-mfcl2710dw ];
  };

  # Use AMD CPU compatible bumblebee
  nixpkgs.overlays = [
    (self: super: { bumblebee = super.bumblebee_amd; })
  ];

  # Set processor architecture
  nixpkgs.hostPlatform = "x86_64-linux";

  # Set current state version
  system.stateVersion = "23.05";
}
