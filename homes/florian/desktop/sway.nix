{ config, pkgs, lib, ... }:

let
  final = config.wayland.windowManager.sway;

  gap = 10;
in {
  programs.alacritty.enable = true;

  wayland.windowManager.sway = {
    enable = true;

    # Use system's sway and Xwayland
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

      # Scale high DPI displays
      output."Unknown 0x1600 0x00000000" = {
        scale = "1.25";
      };

      # Set some basic sane behaviors
      workspaceAutoBackAndForth = true;
      focus.followMouse = "no";

      # Default tools
      menu = "${pkgs.wofi}/bin/wofi --show drun";
      terminal = "${pkgs.foot}/bin/foot";

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
          exec = pkg: exec' pkg pkg.pname;
          exec' = pkg: bin: "exec ${pkg}/bin/${bin}";

          WOBSOCK = "$XDG_RUNTIME_DIR/wob.sock";
      in lib.mkOptionDefault {

        # Lock screen
        "${modifier}+o" = exec' pkgs.swaylock-effects "swaylock";

        # Add logout screen
        "${modifier}+q" = "kill";
        "${modifier}+Shift+q" = exec pkgs.wlogout;

        # Web browser keys
        "${modifier}+BackSpace" = exec pkgs.firefox;
        "${modifier}+Shift+BackSpace" = "${exec pkgs.firefox} --private-window";

        # File browser key
        "${modifier}+Delete" = "exec thunar";

        # Screenshot keys
        "${modifier}+Print" = "${exec pkgs.sway-contrib.grimshot} --notify save window";
        "${modifier}+Shift+Print" = "${exec pkgs.sway-contrib.grimshot} --notify save area";

        # Transparency control
        "${modifier}+bracketleft" = "opacity minus 0.05";
        "${modifier}+bracketright" = "opacity plus 0.05";

        # Volume control
        "--locked XF86AudioLowerVolume" = "${exec pkgs.pamixer} --decrease 5 --get-volume > ${WOBSOCK}";
        "--locked XF86AudioRaiseVolume" = "${exec pkgs.pamixer} --increase 5 --get-volume > ${WOBSOCK}";

        "--locked XF86AudioMute"        = "${exec pkgs.pamixer} --toggle-mute";
        "--locked XF86AudioMicMute"     = "${exec pkgs.pamixer} --default-source --toggle-mute";

        # Playback controls
        "--locked XF86AudioPrev" = "${exec pkgs.playerctl} previous";
        "--locked XF86AudioNext" = "${exec pkgs.playerctl} next";
        "--locked XF86AudioPlay" = "${exec pkgs.playerctl} play-pause";
        "--locked XF86AudioPause" = "${exec pkgs.playerctl} play-pause";
        "--locked XF86AudioStop" = "${exec pkgs.playerctl} stop";

        # Screen brightness controls
        "--locked XF86MonBrightnessUp"   = "${exec pkgs.light} -A 10";
        "--locked XF86MonBrightnessDown" = "${exec pkgs.light} -U 10";
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
          trayOutput = "none";

          fonts = final.config.fonts;

          statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ~/.config/i3status-rust/config-bottom.toml";

          extraConfig = ''
            gaps 0 ${toString gap} ${toString gap} ${toString gap}
          '';
        }
      ];
    };

    extraConfig = ''
      # Forward various environment variables to any dbus services
      exec dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY SWAYSOCK XDG_CURRENT_DESKTOP
    '';
  };
}