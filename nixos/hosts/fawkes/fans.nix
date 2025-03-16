{ ... }:

{
  # Use lower case fan to provide more air to gpu
  hardware.fancontrol = {
    enable = true;

    config = ''
      INTERVAL=10
      DEVPATH=hwmon0=devices/pci0000:00/0000:00:01.1/0000:01:00.0/0000:02:00.0/0000:03:00.0 hwmon6=devices/platform/nct6775.656 hwmon8=devices/pci0000:00/0000:00:18.3
      DEVNAME=hwmon0=amdgpu hwmon6=nct6799 hwmon8=k10temp
      FCTEMPS=hwmon6/pwm5=hwmon8/temp1_input hwmon6/pwm6=hwmon0/temp1_input
      FCFANS=hwmon6/pwm5=hwmon6/fan5_input hwmon6/pwm6=hwmon6/fan6_input
      MINTEMP=hwmon6/pwm5=50 hwmon6/pwm6=40
      MAXTEMP=hwmon6/pwm5=90 hwmon6/pwm6=80
      MINSTART=hwmon6/pwm5=32 hwmon6/pwm6=32
      MINSTOP=hwmon6/pwm5=16 hwmon6/pwm6=16
      MINPWM=hwmon6/pwm5=0 hwmon6/pwm6=0
      MAXPWM=hwmon6/pwm5=255 hwmon6/pwm6=255
    '';
  };
}
