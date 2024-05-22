{ ... }:

{
  # Use lower case fan to provide more air to gpu
  hardware.fancontrol = {
    enable = true;

    config = ''
      INTERVAL=10
      DEVPATH=hwmon0=devices/pci0000:00/0000:00:01.1/0000:01:00.0/0000:02:00.0/0000:03:00.0 hwmon4=devices/platform/nct6775.656 hwmon5=devices/pci0000:00/0000:00:18.3
      DEVNAME=hwmon0=amdgpu hwmon4=nct6799 hwmon5=k10temp
      FCTEMPS=hwmon4/pwm5=hwmon5/temp1_input hwmon4/pwm6=hwmon0/temp1_input
      FCFANS=hwmon4/pwm5=hwmon4/fan5_input hwmon4/pwm6=hwmon4/fan6_input
      MINTEMP=hwmon4/pwm5=50 hwmon4/pwm6=40
      MAXTEMP=hwmon4/pwm5=90 hwmon4/pwm6=80
      MINSTART=hwmon4/pwm5=32 hwmon4/pwm6=32
      MINSTOP=hwmon4/pwm5=24 hwmon4/pwm6=24
      MINPWM=hwmon4/pwm5=24 hwmon4/pwm6=24
      MAXPWM=hwmon4/pwm5=192 hwmon4/pwm6=192
    '';
  };
}
