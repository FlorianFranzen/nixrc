{ config, lib, ... }:

let
  theme = config.theme;
in
{
  # Keep better track of current media player
  services.playerctld.enable = true;

  programs.noctalia = {
    enable = true;

    # Started with the compositor session
    systemd.enable = true;

    settings = {
      shell = {
        corner_radius_scale = 1.0;
        polkit_agent = true;
        settings_show_advanced = true;
        telemetry_enabled = false;

        # Push wallpaper, palette and mode to the login screen
        greeter_sync.auto_sync = true;

        # Lightly translucent panels, still readable
        panel.transparency_mode = "soft";
      };

      # Follow the sun, shell and apps together
      theme = {
        mode = "auto";
        shell_mode = "follow";
      };

      # Same place as the old wlsunset config
      location = {
        latitude = 47.1;
        longitude = 8.5;
      };

      nightlight.enabled = true;

      wallpaper = lib.mkIf (theme.enable && theme.wallpaper.dark != null) {
        default.path = "${theme.wallpaper.dark}";
      };

      # Lock and idle, as swaylock/swayidle before
      lockscreen = {
        enabled = true;
        lock_before_suspend = true;
        blurred_desktop = true;

        # A nudge right after the idle lock unlocks without a password
        grace_period_seconds = 10;
      };

      # Shell feedback sounds (volume, notifications, charger, screenshots)
      audio.enable_sounds = true;

      idle.behavior = {
        lock = {
          enabled = true;
          timeout = 600;
          action = "lock";
        };
        screen-off = {
          enabled = true;
          timeout = 900;
          action = "screen_off";
        };
      };

      notification.enable_daemon = true;

      # Official plugin: umbriel layout/submap in the bar
      plugins = {
        enabled = [ "noctalia/umbriel-companion" ];
        auto_update = "official";
      };

      widget.umbriel-layout.type = "noctalia/umbriel-companion:bar";

      # Everything the two sway bars had, in one bar
      bar.main = {
        position = "top";

        # Widgets in pills
        capsule = true;
        start = [ "launcher" "workspaces" "umbriel-layout" "active-window" ];
        center = [ "clock" ];
        end = [
          "media"
          "tray"
          "notifications"
          "clipboard"
          "network"
          "bluetooth"
          "volume"
          "brightness"
          "battery"
          "control-center"
          "session"
        ];
      };
    };
  };
}
