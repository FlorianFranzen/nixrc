{ pkgs, ... }:

{
  # FIXME Remove once the sticky second fan (EC fan 1, hwmon fan2) is cleaned or replaced.
  # It needs ~60% duty to start from standstill, while the EC only ramps to ~30-40%,
  # so it stalls after every stop. Once spinning, EC auto control keeps it going fine.
  systemd.services.fan-kick = {
    description = "Kick stalled second fan back into motion";
    path = [ pkgs.framework-tool ];

    script = ''
      while sleep 10; do
        name=$(grep -lx framework_laptop /sys/class/hwmon/hwmon*/name) || continue
        hw=''${name%/name}

        # EC wants cooling, but the second fan did not start
        if [ "$(cat "$hw/fan1_input")" -gt 0 ] && [ "$(cat "$hw/fan2_input")" -eq 0 ]; then
          echo "fan2 stalled while fan1 at $(cat "$hw/fan1_input") rpm, kicking"
          framework_tool --fansetduty 1 100 > /dev/null
          sleep 3
          framework_tool --autofanctrl > /dev/null
        fi
      done
    '';

    serviceConfig = {
      Restart = "always";
      RestartSec = 10;
    };

    wantedBy = [ "multi-user.target" ];
  };
}
