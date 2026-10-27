{ config, pkgs, lib, ... }:

let
  theme = config.theme;

  toml = pkgs.formats.toml { };

  settings = {
    # Colours are rendered by noctalia (see theming.nix) so they follow
    # light/dark mode; until the first render the file is simply absent
    include.optional.files = [ "noctalia.toml" ];

    general = {
      xwayland = true;
      show_cheatsheet = false;
    };

    # Default input config
    input = {
      keyboard = {
        layout = "eu";
        options = "compose:ralt";
        numlock_toggle = true;
      };

      touchpad = {
        natural_scroll = true;
        tap = false;
      };

      mouse = {
        natural_scroll = true;
        accel_profile = "flat";
      };

      cursor = lib.optionalAttrs (theme.cursorTheme != null) {
        theme = theme.cursorTheme.name;
        size = theme.cursorSize;
      };

      focus.follows_mouse = false;
    };

    # Scale high DPI displays, enable fancy features on fancy displays
    output = {
      "California Institute of Technology 0x1600 Unknown".scale = 1.25;
      "BOE 0x0BC9 Unknown".scale = 1.25;
      "GIGA-BYTE TECHNOLOGY CO., LTD. M34WQ 0x000005B5".vrr = "always";
      "GIGA-BYTE TECHNOLOGY CO., LTD. AORUS FO32U2P 24150B000713" = {
        mode = "3840x2160@240";
        vrr = "always";
      };
    };

    workspaces.back_and_forth = true;

    # Scrolling layout with the same gap as sway
    layout = {
      mode = "scrolling";
      gap = 20;
    };

    # Rounded, blurred look to match the shell
    appearance = {
      prefer_no_csd = true;
      border_width = 2;
      corner_radius = 12;

      blur = {
        enabled = true;
        optimized = true;
        passes = 3;
        radius = 3;
        noise = 0.02;
        brightness = 0.9;
        contrast = 0.9;
        saturation = 1.1;
      };
    };

    # Blurred wallpaper and workspace previews in the overview
    overview = {
      background_blur = true;
      workspace_wallpaper = true;
      shortcuts = true;
    };

    # Slightly dim unfocused windows, as on KDE
    animation.dim_unfocused = {
      enabled = true;
      dim = 0.1;
    };

    window_rule = [
      # Blur every window
      { blur = true; }

      # Float noctalia's own windows
      {
        match.app_id = "^dev.noctalia.Noctalia$";
        default_floating = true;
        default_floating_size_px = { width = 1020;  height = 900; };
      }
      {
        match.app_id = "^dev.noctalia.UmbrielSharePicker$";
        default_floating = true;
        default_floating_size_px = { width = 800; height = 600; };
      }

      # Keep picture in picture in a corner
      {
        match.title = "^(Picture-in-Picture|Picture in picture)$";
        default_floating = true;
        default_maximize = false;
        default_position = { x = 20; y = 20; anchor = "bottom_right"; };
      }
    ];

    # Blur behind the shell surfaces
    layer_rule = [
      {
        match.namespace = "^noctalia-(bar-[^\"]+|notification|dock|panel|attached-panel|osd|desktop-widget-[^\"]*)$";
        blur = true;
        blur_ignore_alpha = 0.5;
        blur_popups = true;
        blur_optimized = false;
      }
    ];

    keybinds = config.wayland.umbriel.keybinds;
  };

  configFile = toml.generate "umbriel-config.toml" settings;
in
{
  # Rendered by keybinds.nix
  options.wayland.umbriel.keybinds = lib.mkOption {
    type = toml.type;
    default = { };
    description = "Umbriel [keybinds] table.";
  };

  config = {
    # Validate the config at build time
    xdg.configFile."umbriel/config.toml".source = pkgs.runCommand "umbriel-config.toml" { } ''
      ${pkgs.umbriel}/bin/umbriel config validate -c ${configFile}
      cp ${configFile} $out
    '';
  };
}
