{ config, pkgs, lib, profiles, homes, ... }:
{
  imports = 
    (with profiles; [ corp gaming media mail office podman virtual ]) ++
    (with profiles.develop; [ minimal extra cross cad linux net ]) ++
    (with profiles.desktops; [ sddm kde sway ]) ++
    (with profiles.networks; [ iwd ]) ++
    (with profiles.hardware; [
      common-cpu-amd
      common-cpu-amd-pstate
      common-gpu-amd
      common-pc-ssd
      android
      pipewire
      traktor-kontrol
      smartcard
      wooting
      zsa
    ]);

  # Install full desktop environment
  home-manager.users.florian = homes.desktop-full-gruvbox;

  # Provided updated cpu microcode and basic firmwares
  hardware.cpu.amd.updateMicrocode = true;
  hardware.firmware = [ pkgs.linux-firmware ];

  # Enable full performace of cpu and gpu
  hardware.amdgpu.overdrive.enable = true;

  # Keep firmware up to date
  services.fwupd.enable = true;

  services.udev.extraRules = ''
    # Provide access to mainboard RGB controller
    SUBSYSTEMS=="usb|hidraw", ATTRS{idVendor}=="0b05", ATTRS{idProduct}=="19af", TAG+="uaccess"
    # Provide access to gigabyte display
    SUBSYSTEMS=="usb|hidraw", ATTRS{idVendor}=="0bda", ATTRS{idProduct}=="1100", TAG+="uaccess"
  '';

  # TODO: Run openrgb -d 0 -z 2 -s 40 -m static -c 882200

  # Install cpu and gpu clock tooling
  programs.corectrl.enable = true;

  # Install additional tooling
  environment.systemPackages = [
    pkgs.cryptsetup
  ];

  # Set processor architecture
  nixpkgs.hostPlatform = "x86_64-linux";

  # Current state version
  system.stateVersion = "24.11";
}
