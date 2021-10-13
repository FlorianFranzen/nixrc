{ config, pkgs, ... }:

{
  # Enable ZFS support
  boot.supportedFilesystems = [ "zfs" ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";

  nixpkgs.config.packageOverrides = pkgs: {
    # Enable sensord deamon build
    lm_sensors = pkgs.lm_sensors.override { sensord = true; }; 
  };

  # Additional packages 
  environment.systemPackages = with pkgs; [
    lm_sensors smartmontools
  ];

  # Disable power button
  services.logind.extraConfig = "HandlePowerKey=suspend";

  # Cool HDD array based on SMART temp
  services.thinkfan = {
    enable = true;
    smartSupport = true;
    fans = [{
      type  = "hwmon";
      query = "/sys/class/hwmon/hwmon0/device/pwm2";
    }];
    sensors = [
      { type = "atasmart"; query = "/dev/sdb"; }
      { type = "atasmart"; query = "/dev/sdc"; }
      { type = "atasmart"; query = "/dev/sdd"; }
      { type = "atasmart"; query = "/dev/sde"; }
      { type = "atasmart"; query = "/dev/sdf"; }
    ];
    levels = [
      [  0   0  28]
      [ 90  25  33]
      [110  30  38]
      [130  35  43]
      [150  40  48]
      [170  45  53]
    ];
    # Slower curve:
    #  ( 90,  35,  43)
    #  (110,  40,  48)
    #  (150,  45,  53)
    #  (190,  50, 100) 
  };

  system.stateVersion = "20.09";
}
