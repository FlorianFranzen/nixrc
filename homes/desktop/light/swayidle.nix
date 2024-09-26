{ config, pkgs, ... }:

let
  sway = config.wayland.windowManager.sway.package;

  swaylock = "${pkgs.swaylock-effects}/bin/swaylock";
  swaymsg = "${sway}/bin/swaymsg";

  cmd_lock = "${swaylock} --daemonize";
  cmd_off = "${swaymsg} 'output * dpms off'";
  cmd_on = "${swaymsg} 'output * dpms on'";
in
{
  services.swayidle = {
    enable = true;

    timeouts = [
      { timeout = 600; command = cmd_lock; }
      { timeout = 900; command = cmd_off; resumeCommand = cmd_on; }
    ];

    events = [
      { event = "before-sleep"; command = cmd_lock; }
    ];
  };
}
