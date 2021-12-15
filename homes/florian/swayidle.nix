{ pkgs, ... }:

let
  swaylock = "${pkgs.swaylock-effects}/bin/swaylock";
  swaymsg = "${pkgs.sway}/bin/swaymsg";
in
{
  home.file.".config/swayidle/config".text = ''
    timeout 300 '${swaylock} -f'
    timeout 600 '${swaymsg} "output * dpms off"' resume '${swaymsg} "output * dpms on"'
    before-sleep '${swaylock} -f'
  '';

  wayland.windowManager.sway.extraConfig = ''
    exec ${pkgs.swayidle}/bin/swayidle -w
  '';
}
