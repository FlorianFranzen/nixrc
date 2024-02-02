{ config, pkgs, lib, profiles, homes, ... }:
{
  imports = 
    (with profiles; [ corp gaming media mail office podman ]) ++
    (with profiles.develop; [ minimal extra cross linux ]) ++
    (with profiles.desktops; [ gdm sway ]) ++
    (with profiles.networks; [ iwd ]) ++
    (with profiles.hardware; [
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

  # Install full desktop environment
  home-manager.users.florian = homes.desktop-gruvbox;

  # Provided updated cpu microcode and basic firmwares
  hardware.cpu.amd.updateMicrocode = true;
  hardware.firmware = [ pkgs.linux-firmware ];

  # Make hip available at known-path
  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  ];

  # Set processor architecture
  nixpkgs.hostPlatform = "x86_64-linux";

  # Current state version
  system.stateVersion = "23.11";
}
