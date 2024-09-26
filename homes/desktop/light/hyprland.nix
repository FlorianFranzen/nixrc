{ pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;

    package = pkgs.hyprland;

    extraConfig = ''
      # Hardware configs
      monitor = HDMI-A-1, highres, 0x0, 1.25

      # Switch to workspace
      bind = SUPER, 1, workspace, 1
      bind = SUPER, 2, workspace, 2
      bind = SUPER, 3, workspace, 3
      bind = SUPER, 4, workspace, 4
      bind = SUPER, 5, workspace, 5
      bind = SUPER, 6, workspace, 6
      bind = SUPER, 7, workspace, 7
      bind = SUPER, 8, workspace, 8
      bind = SUPER, 9, workspace, 9

      # Move to workspace
      bind = SUPER_SHIFT, 1, movetoworkspace, 1
      bind = SUPER_SHIFT, 2, movetoworkspace, 2
      bind = SUPER_SHIFT, 3, movetoworkspace, 3
      bind = SUPER_SHIFT, 4, movetoworkspace, 4
      bind = SUPER_SHIFT, 5, movetoworkspace, 5
      bind = SUPER_SHIFT, 6, movetoworkspace, 6
      bind = SUPER_SHIFT, 7, movetoworkspace, 7
      bind = SUPER_SHIFT, 8, movetoworkspace, 8
      bind = SUPER_SHIFT, 9, movetoworkspace, 9

      # Manipulate windows
      bind = SUPER, F, fullscreen
      bind = SUPER_SHIFT, F, fakefullscreen

      # Cycle windows
      bind = SUPER, N, cyclenext
      bind = SUPER, B, cyclenext, prev

      # Media control
      bind = , XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
      bind = , XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+

      # Kill and exit
      bind = SUPER, Q, killactive
      bind = SUPER_SHIFT, Q, exec, ${pkgs.wlogout}/bin/wlogout

      # Application keybindings
      bind = SUPER, Return, exec, ${pkgs.foot}/bin/foot

      bind = SUPER, Backspace, exec, ${pkgs.firefox}/bin/firefox
      bind = SUPER_SHIFT, Backspace, exec, ${pkgs.firefox}/bin/firefox --private-window

      bind = SUPER, D, exec, ${pkgs.wofi}/bin/wofi --show drun
      bind = SUPER_SHIFT, D, exec, ${pkgs.wofi}/bin/wofi --show run

      bind = SUPER, Delete, exec, thunar

      bind = SUPER, O, exec, ${pkgs.swaylock-effects}/bin/swaylock
    '';
  };
}
