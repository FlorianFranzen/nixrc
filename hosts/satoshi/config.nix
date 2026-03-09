{ config, pkgs, lib, profiles, homes, ... }:

{
  imports =
    (with profiles; [ corp docker gaming laptop media mail office ]) ++
    (with profiles.develop; [ minimal extra cross linux net ]) ++
    (with profiles.desktops; [ gdm sway ]) ++
    (with profiles.networks; [ iwd ]) ++
    (with profiles.hardware; [
      secure-boot
      common-cpu-amd
      common-cpu-amd-pstate
      common-gpu-amd
      common-pc-ssd
      android
      pipewire
      smartcard
      wooting
      zsa
    ]);

  # Install light desktop environment
  home-manager.users.florian = homes.desktop-light-solarized;

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.eno1.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp4s0.useDHCP = lib.mkDefault true;

  # Add some fancontrol 
  services.thermald.enable = true;

  # Enable microcode updates
  hardware.cpu.amd.updateMicrocode = true;
  hardware.firmware = [ pkgs.linux-firmware ];

  # Disable GPU unless overridden in specialization
  hardware.nvidiaOptimus.disable = lib.mkDefault true;

  # Use AMD CPU compatible bumblebee
  nixpkgs.overlays = [
    (self: super: { bumblebee = super.bumblebee_amd; })
  ];

  # Set processor architecture
  nixpkgs.hostPlatform = "x86_64-linux";

  # Set current state version
  system.stateVersion = "24.11";
}
