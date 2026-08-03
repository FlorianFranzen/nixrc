{ pkgs, profiles, homes, ... }:
{
  imports = 
    (with profiles; [ corp gaming media mail office podman virtual ]) ++
    (with profiles.develop; [ minimal extra cross cad linux net ]) ++
    (with profiles.desktops; [ sddm kde ]) ++
    (with profiles.networks; [ iwd ]) ++
    (with profiles.hardware; [
      common-cpu-amd
      common-cpu-amd-pstate
      common-gpu-amd
      common-pc-ssd
      android
      focusrite-scarlett
      gbmonctl
      pipewire
      rocm
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

  # Install cpu and gpu clock tooling
  programs.corectrl.enable = true;

  # Install additional tooling
  environment.systemPackages = [
    pkgs.cryptsetup
  ];

  services.clamav = {
    daemon.enable = true;
    fangfrisch.enable = true;
    updater.enable = true;
  };
}
