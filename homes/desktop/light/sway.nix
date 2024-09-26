{ config, pkgs, lib, ... }:

let
  final = config.wayland.windowManager.sway;

  exec = pkg: exec' pkg pkg.pname;
  exec' = pkg: bin: "exec ${pkg}/bin/${bin}";

  thunar = with pkgs; xfce.thunar.override { 
    thunarPlugins = [
      xfce.thunar-volman
      xfce.thunar-archive-plugin
    ];
  };
 
  gap = 20;
in {

  wayland.windowManager.sway = {
    # Enable and use default package after overlays
    enable = true;
    package = pkgs.sway;

    # Disabled, broken on vulkan renderer
    checkConfig = false;

    config = {
      # Default input config
      input = { 
        "type:keyboard" = {
          xkb_layout = "eu";
          xkb_options = "compose:ralt";
          xkb_numlock = "enabled";
        };

        "type:touchpad" = {
          natural_scroll = "enabled";
          scroll_method = "two_finger";
          tap = "disabled";
        };

        "type:pointer" = {
          natural_scroll = "enabled";
          accel_profile = "flat";
        };
      };

      # Scale high DPI displays
      output."California Institute of Technology 0x1600 Unknown" = {
        scale = "1.25";
      };

      # Enable fancy features on fancy displays
      output."GIGA-BYTE TECHNOLOGY CO., LTD. M34WQ 0x000005B5" = {
        adaptive_sync = "on";
      };

      output."GIGA-BYTE TECHNOLOGY CO., LTD. AORUS FO32U2P 24150B000713" = {
        mode = "3840x2160@240Hz";
        adaptive_sync = "on";
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
          cfg = final.config;

          WOBSOCK = "$XDG_RUNTIME_DIR/wob.sock";
      in lib.mkOptionDefault {
        # Move workspace between outputs
        "${cfg.modifier}+Ctrl+${cfg.left}"  = "move workspace output left";
        "${cfg.modifier}+Ctrl+${cfg.down}"  = "move workspace output down";
        "${cfg.modifier}+Ctrl+${cfg.up}"    = "move workspace output up";
        "${cfg.modifier}+Ctrl+${cfg.right}" = "move workspace output right";

        "${cfg.modifier}+Ctrl+Left"  = "move workspace output left";
        "${cfg.modifier}+Ctrl+Down"  = "move workspace output down";
        "${cfg.modifier}+Ctrl+Up"    = "move workspace output up";
        "${cfg.modifier}+Ctrl+Right" = "move workspace output right";

        # Fullscreen container in split parent  
        "${cfg.modifier}+Shift+f" = "split v; focus parent; fullscreen toggle; focus child";    

        # Regular PATH-based run menu
        "${cfg.modifier}+Shift+d" = "${exec pkgs.wofi} --show run";

        # Lock screen
        "${cfg.modifier}+o" = exec' pkgs.swaylock-effects "swaylock";

        # Add logout screen
        "${cfg.modifier}+q"       = "kill";
        "${cfg.modifier}+Shift+q" = exec pkgs.wlogout;

        # Add emacs pgtk ui
        "${cfg.modifier}+Shift+Return" = "exec emacsclient --create-frame";

        # Web browser keys
        "${cfg.modifier}+BackSpace"       = exec pkgs.firefox;
        "${cfg.modifier}+Shift+BackSpace" = "${exec pkgs.firefox} --private-window";

        # File browser key
        "${cfg.modifier}+Delete" = exec' thunar "thunar";

        # Screenshot keys
        "${cfg.modifier}+Print"       = "${exec pkgs.sway-contrib.grimshot} --notify save window";
        "${cfg.modifier}+Shift+Print" = "${exec pkgs.sway-contrib.grimshot} --notify save area";

        # Transparency control
        "${cfg.modifier}+bracketleft"  = "opacity minus 0.05";
        "${cfg.modifier}+bracketright" = "opacity plus 0.05";

        # Mark and switch
        "${cfg.modifier}+m" = "mode mark";
        "${cfg.modifier}+t" = "mode switch";

        # Volume control
        "--locked XF86AudioLowerVolume" = "${exec pkgs.pamixer} --decrease 5 --get-volume > ${WOBSOCK}";
        "--locked XF86AudioRaiseVolume" = "${exec pkgs.pamixer} --increase 5 --get-volume > ${WOBSOCK}";

        "--locked XF86AudioMute"        = "${exec pkgs.pamixer} --toggle-mute";
        "--locked XF86AudioMicMute"     = "${exec pkgs.pamixer} --default-source --toggle-mute";

        # Playback controls
        "--locked XF86AudioPrev"  = "${exec pkgs.playerctl} previous";
        "--locked XF86AudioNext"  = "${exec pkgs.playerctl} next";
        "--locked XF86AudioPlay"  = "${exec pkgs.playerctl} play-pause";
        "--locked XF86AudioPause" = "${exec pkgs.playerctl} play-pause";
        "--locked XF86AudioStop"  = "${exec pkgs.playerctl} stop";

        # Screen brightness controls
        "--locked XF86MonBrightnessUp"   = "${exec pkgs.light} -A 10";
        "--locked XF86MonBrightnessDown" = "${exec pkgs.light} -U 10";
      };

      modes = lib.mkOptionDefault {
        # Mark and switch
        mark = {
          "1" = "mark 1; mode default";
          "2" = "mark 2; mode default";
          "3" = "mark 3; mode default";
          "4" = "mark 4; mode default";
          "5" = "mark 5; mode default";
          "6" = "mark 6; mode default";
          "7" = "mark 7; mode default";
          "8" = "mark 8; mode default";
          "9" = "mark 9; mode default";
          "0" = "mark 0; mode default";
          Return = "mode default";
          Escape = "mode default";
        };
        switch = {
          "1" = "[con_mark=1] focus; mode default";
          "2" = "[con_mark=2] focus; mode default";
          "3" = "[con_mark=3] focus; mode default";
          "4" = "[con_mark=4] focus; mode default";
          "5" = "[con_mark=5] focus; mode default";
          "6" = "[con_mark=6] focus; mode default";
          "7" = "[con_mark=7] focus; mode default";
          "8" = "[con_mark=8] focus; mode default";
          "9" = "[con_mark=9] focus; mode default";
          "0" = "[con_mark=0] focus; mode default";
          Return = "mode default";
          Escape = "mode default";
        };
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
            binding_mode_indicator no
          '';
        }
      ];
    };

    extraConfig = ''
      bindgesture swipe:right workspace prev
      bindgesture swipe:left workspace next

      bindgesture swipe:4:up move scratchpad
      bindgesture swipe:4:down [floating] scratchpad show

      bindgesture pinch:inward fullscreen disable
      bindgesture pinch:outward fullscreen enable
    '';
  };
}
