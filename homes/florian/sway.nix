{config, pkgs, lib, ...}:

{
  wayland.windowManager.sway = {
    enable = true;
    config = {
      # Default input config
      input."*" = {
        xkb_layout = "eu";
        xkb_options = "compose:ralt,terminate:ctrl_alt_bksp";
        xkb_numlock = "enabled";

        natural_scroll = "enabled";
        scroll_method = "two_finger";
        tap = "disabled";
      };

      focus.followMouse = "no";

      # Default tools
      menu = "${pkgs.wofi}/bin/wofi --show drun";
      terminal = "${pkgs.alacritty}/bin/alacritty";

      # Basic look
      gaps = {
        inner = 10;
        outer = 0;
      };

      # Basic keybindings
      modifier = "Mod4";

      # Extended key bindings
      keybindings = let
          modifier = config.wayland.windowManager.sway.config.modifier;
      in lib.mkOptionDefault {
        # Browser keys
        "${modifier}+BackSpace" = "exec ${pkgs.firefox}/bin/firefox";
        "${modifier}+Shift+BackSpace" = "exec ${pkgs.firefox}/bin/firefox --private-window";

        # Volume control
        "--locked XF86AudioLowerVolume" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -5%";
        "--locked XF86AudioRaiseVolume" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ +5%";
        "--locked XF86AudioMute"        = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle";
        "--locked XF86AudioMicMute"     = "exec ${pkgs.pulseaudio}/bin/pactl set-source-mute @DEFAULT_SOURCE@ toggle";

        # Playback controls
        "--locked XF86AudioPrev" = "exec ${pkgs.playerctl}/bin/playerctl previous";
        "--locked XF86AudioNext" = "exec ${pkgs.playerctl}/bin/playerctl next";
        "--locked XF86AudioPlay" = "exec ${pkgs.playerctl}/bin/playerctl play-pause";
        "--locked XF86AudioStop" = "exec ${pkgs.playerctl}/bin/playerctl stop";

        # Screen brightness controls
        "--locked XF86MonBrightnessUp"   = "exec ${pkgs.light}/bin/light -A 10";
        "--locked XF86MonBrightnessDown" = "exec ${pkgs.light}/bin/light -U 10";
      };
    };
  };

  programs.mako = {
    enable = true;
    defaultTimeout = 30000;
  };
}
