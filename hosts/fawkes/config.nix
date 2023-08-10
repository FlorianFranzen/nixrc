{ config, pkgs, lib, suites, profiles, hardware, hmUsers, ... }:
{
  imports = suites.full ++
    [ profiles.corp profiles.podman profiles.networks.iwd ] ++
    (with profiles.develop; [ minimal extra cross linux ]) ++
    (with profiles.desktops; [ gdm sway ]) ++
    (with hardware; [
      common-cpu-amd-pstate
      common-gpu-amd
      common-pc-ssd
      android
      smartcard
      zsa
    ]);

  # Install full desktop environment
  home-manager.users.florian = hmUsers.florian-desktop;

  # Use latest kernel for better compatibility
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [ "amdgpu.sg_display=0" "amdgpu.hw_i2c=1" "amdgpu.dc=1" ];

  boot.blacklistedKernelModules = [ "asus_nb_wmi" "eeepc_wmi" ];
  boot.extraModulePackages = [ pkgs.linuxPackages_latest.nct6775 ];

  # Allow use of zfs
  boot.supportedFilesystems = [ "zfs" ];

  # Current state version
  system.stateVersion = "23.11";
}
