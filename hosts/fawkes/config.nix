{ config, pkgs, lib, suites, profiles, hardware, hmUsers, ... }:
{
  imports = suites.full ++
    [ profiles.corp profiles.podman profiles.networks.iwd ] ++
    (with profiles.develop; [ minimal extra cross linux ]) ++
    (with profiles.desktops; [ gdm sway ]) ++
    (with hardware; [
      common-cpu-amd-pstate
      common-cpu-amd-raphael-igpu
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

  # Allow use of zfs
  boot.supportedFilesystems = [ "zfs" ];

  # Current state version
  system.stateVersion = "23.11";
}
