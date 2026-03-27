{ ... }:

{
  # Use lower case fan to provide more air to gpu
  hardware.fancontrol = {
    enable = true;

    config = ''
      INTERVAL=10
      DEVPATH=hwmon0=devices/pci0000:00/0000:00:01.1/0000:01:00.0/0000:02:00.0/0000:03:00.0 hwmon7=devices/platform/nct6775.656 hwmon8=devices/pci0000:00/0000:00:18.3
      DEVNAME=hwmon0=amdgpu hwmon7=nct6799 hwmon8=k10temp
      FCTEMPS=hwmon7/pwm5=hwmon8/temp1_input hwmon7/pwm6=hwmon0/temp1_input
      FCFANS=hwmon7/pwm5=hwmon7/fan5_input hwmon7/pwm6=hwmon7/fan6_input
      MINTEMP=hwmon7/pwm5=50 hwmon7/pwm6=40
      MAXTEMP=hwmon7/pwm5=90 hwmon7/pwm6=80
      MINSTART=hwmon7/pwm5=32 hwmon7/pwm6=32
      MINSTOP=hwmon7/pwm5=16 hwmon7/pwm6=16
      MINPWM=hwmon7/pwm5=0 hwmon7/pwm6=0
      MAXPWM=hwmon7/pwm5=255 hwmon7/pwm6=255
    '';
  };
}
