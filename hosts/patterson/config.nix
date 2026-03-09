{ config, pkgs, profiles, username, ... }:

{
  imports = with profiles; [
    develop.minimal
    services.teddycloud
  ];

  # Enable direct access to serial ports
  users.extraUsers.${username}.extraGroups = [ "dialout" ];
 
  # Use the extlinux boot loader. (NixOS wants to enable GRUB by default)
  boot.loader.grub.enable = false;
  # Enables the generation of /boot/extlinux/extlinux.conf
  boot.loader.generic-extlinux-compatible.enable = true;

  # Use newer kernels to avoid hardware problems
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Increase file pointer count
  boot.kernel.sysctl."fs.file-max" = 100000;

  # Open ports for subspace farmer
  networking.firewall.allowedTCPPorts = [ 30333 30433 30533 ];

  # Open port for UPnP
  networking.firewall.allowedUDPPorts = [ 1900 ];

  # Optimize fan usage
  hardware.fancontrol = {
    enable = true;
    config = ''
      INTERVAL=10
      DEVPATH=hwmon1=devices/virtual/thermal/thermal_zone0 hwmon4=devices/platform/pwm-fan
      DEVNAME=hwmon1=cpu_thermal hwmon4=pwmfan
      FCTEMPS=hwmon4/pwm1=hwmon1/temp1_input
      MINTEMP=hwmon4/pwm1=35
      MAXTEMP=hwmon4/pwm1=60
      MINSTART=hwmon4/pwm1=100
      MINSTOP=hwmon4/pwm1=70
    '';
  };

  # Set processor architecture
  nixpkgs.hostPlatform = "aarch64-linux";

  # Current state version
  system.stateVersion = "22.11";
}

