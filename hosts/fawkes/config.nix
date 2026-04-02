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
      pipewire
      focusrite-scarlett
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
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="0bda", ATTRS{idProduct}=="1100", MODE="0660", TAG+="uaccess"
  '';

  # Configure static lighting color with OpenRGB
  systemd.services.openrgb-setup = {
    description = "Configure OpenRGB devices after boot";

    script = ''
      # Case lighting on port 2 with 40 leds
      ${pkgs.openrgb}/bin/openrgb -d "ASUS ProArt X670E-CREATOR WIFI" -z 2 -s 40 -m static -c 882200
    '';

    serviceConfig.Type = "oneshot";

    wantedBy = [ "multi-user.target" ];
  };

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
