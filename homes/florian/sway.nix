{config, pkgs, lib, ...}:

let
  final = config.wayland.windowManager.sway;

  gap = 10;
in {
  programs.alacritty.enable = true;

  wayland.windowManager.sway = {
    enable = true;

    # Currently uses system sway
    package = null;

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

      # Set some basic sane behaviors
      workspaceAutoBackAndForth = true;
      focus.followMouse = "no";

      # Default tools
      menu = "${pkgs.wofi}/bin/wofi --show drun";
      terminal = "${pkgs.alacritty}/bin/alacritty";

      # Basic look
      gaps = {
        inner = gap;
        outer = 0;
      };

      # Basic keybindings
      modifier = "Mod4";

      # Extended key bindings
      keybindings = let
          modifier = final.config.modifier;
      in lib.mkOptionDefault {
        # Web browser keys
        "${modifier}+BackSpace" = "exec ${pkgs.firefox}/bin/firefox";
        "${modifier}+Shift+BackSpace" = "exec ${pkgs.firefox}/bin/firefox --private-window";

        # File browser key
        "${modifier}+Delete" = "exec thunar";

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

      # Add i3status-based top and bottom bars
      bars = [
        {
          position = "top";

          fonts = final.config.fonts;

          statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ~/.config/i3status-rust/config-top.toml";

          extraConfig = ''
            gaps ${toString gap} ${toString gap} 0 ${toString gap}
          '';
        }
        {
          position = "bottom";
          workspaceButtons = false;

          fonts = final.config.fonts;

          statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ~/.config/i3status-rust/config-bottom.toml";

          extraConfig = ''
            gaps 0 ${toString gap} ${toString gap} ${toString gap}
          '';
        }
      ];
    };
  };
}
