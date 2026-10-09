{ ... }: 

{
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
}

