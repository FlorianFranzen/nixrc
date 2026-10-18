{ config, pkgs, lib, ... }:

let
  final = config.wayland.windowManager.sway;

  gap = 20;
in {
  # Keep better track of current media player
  services.playerctld.enable = true;

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

      output."BOE 0x0BC9 Unknown" = {
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
      terminal = "${pkgs.foot}/bin/footclient";

      # Basic look
      gaps = {
        inner = gap;
        outer = 0;
      };

      floating.titlebar = false;
      window.titlebar = false;

      # Keybindings live in keybinds.nix, rendered from the shared set
      modifier = "Mod4";

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

      # Configure switch bindings
      bindswitches = {
        "lid:on" = {
          action = "output eDP-1 disable";
          locked = true;
        };
        "lid:off" = {
          action = "output eDP-1 enable";
          locked = true;
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

    # Configure gesture bindings
    extraConfig = ''
      bindgesture swipe:right workspace prev
      bindgesture swipe:left workspace next

      bindgesture swipe:4:up move scratchpad
      bindgesture swipe:4:down [floating] scratchpad show

      bindgesture pinch:inward fullscreen disable
      bindgesture pinch:outward fullscreen enable
    '';

    # Provide additional env vars to systemd
    systemd.variables = lib.mkOptionDefault [ "XDG_SESSION_ID" ];

    # Match base system dbus implementation
    systemd.dbusImplementation = "broker";
  };
}
