{ config, pkgs, lib, profiles, homes, ... }:
{
  imports = 
    (with profiles; [ corp gaming media mail office podman ]) ++
    (with profiles.develop; [ minimal extra cross linux ]) ++
    (with profiles.desktops; [ gdm sway ]) ++
    (with profiles.networks; [ iwd ]) ++
    (with profiles.hardware; [
      common-cpu-amd-pstate
      common-gpu-amd
      common-pc-ssd
      android
      pipewire
      smartcard
      zsa
    ]);

  # Install full desktop environment
  home-manager.users.florian = homes.florian-desktop;

  # Use latest kernel for better compatibility
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [ "amdgpu.sg_display=0" "amdgpu.hw_i2c=1" "amdgpu.dc=1" ];

  boot.blacklistedKernelModules = [ "asus_nb_wmi" "eeepc_wmi" ];
  boot.extraModulePackages = [ pkgs.linuxPackages_latest.nct6775 ];

  # Allow use of zfs
  boot.supportedFilesystems = [ "zfs" ];

  # Set processor architecture
  nixpkgs.hostPlatform = "x86_64-linux";

  # Current state version
  system.stateVersion = "23.11";
}
