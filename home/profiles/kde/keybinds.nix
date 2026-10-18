# Render the shared keybind set (home/modules/keybinds.nix) for KDE
{ config, lib, ... }:

let
  keys = config.keybinds;

  # KDE writes Shift+digit as the shifted symbol
  shifted = {
    "1" = "!"; "2" = "@"; "3" = "#"; "4" = "$"; "5" = "%";
    "6" = "^"; "7" = "&"; "8" = "*"; "9" = "("; "0" = ")";
  };

  toKde = chord:
    let
      parts = lib.splitString "+" chord;
      mods = lib.init parts;
      key = lib.last parts;
    in
    if lib.elem "Shift" mods && shifted ? ${key}
    then lib.concatStringsSep "+" (lib.remove "Shift" mods ++ [ shifted.${key} ])
    else chord;

  render = chord: map toKde (lib.toList chord);

  perWorkspace = prefix: chords:
    lib.mapAttrs' (n: chord: lib.nameValuePair "${prefix} ${n}" (render chord)) chords;
in
{
  programs.plasma = {
    shortcuts = {
      # Power and lock controls
      ksmserver = {
        "Lock Session" = render keys.lock;
        "Log Out" = render keys.logout;
      };

      # Desktop and Window management
      kwin = {
        # Alerting and expose overviews
        "Activate Window Demanding Attention" = render keys.focusUrgent;

        Expose = render keys.overview;
        ExposeAll = render keys.overviewAll;
        ExposeClass = render keys.overviewClass;

        # Opacity controls
        "Decrease Opacity" = render keys.opacityDown;
        "Increase Opacity" = render keys.opacityUp;

        # Krohnkite tiling
        KrohnkiteToggleFloat = render keys.toggleFloat;
        KrohnkiteFloatAll = render keys.floatAll;

        KrohnkiteFocusLeft = render keys.focusLeft;
        KrohnkiteFocusDown = render keys.focusDown;
        KrohnkiteFocusUp = render keys.focusUp;
        KrohnkiteFocusRight = render keys.focusRight;

        KrohnkiteDecrease = render keys.shrink;
        KrohnkiteIncrease = render keys.grow;

        KrohnkitePreviousLayout = render keys.prevLayout;
        KrohnkiteNextLayout = render keys.nextLayout;

        KrohnkiteRotate = render keys.rotate;
        KrohnkiteRotatePart = render keys.rotatePart;
        KrohnkiteSetMaster = render keys.setMaster;

        KrohnkiteShiftLeft = render keys.moveLeft;
        KrohnkiteShiftDown = render keys.moveDown;
        KrohnkiteShiftUp = render keys.moveUp;
        KrohnkiteShiftRight = render keys.moveRight;

        # Window switching
        "Walk Through Windows" = render keys.nextWindow;
        "Walk Through Windows (Reverse)" = render keys.prevWindow;

        "Walk Through Windows Alternative" = render keys.nextWindowAlt;
        "Walk Through Windows Alternative (Reverse)" = render keys.prevWindowAlt;

        # Window manipulation
        "Window Close" = render keys.close;
        "Window Fullscreen" = render keys.fullscreen;
        "Window Operations Menu" = render keys.windowMenu;
        "Window Minimize" = render keys.minimize;
        "Window Maximize" = render keys.maximize;

        # Zoom controlls
        view_actual_size = render keys.zoomReset;
        view_zoom_in = render keys.zoomIn;
        view_zoom_out = render keys.zoomOut;

        # Unbind conflicts
        "Edit Tiles" = "none";
        "Grid View" = "none";
        "Overview" = "none";
        "Show Desktop" = "none";
      }
      # Desktop switching
      // perWorkspace "Switch to Desktop" keys.workspace
      // perWorkspace "Window to Desktop" keys.moveToWorkspace;

      # Plasmashell integration
      plasmashell = {
        "next activity" = render keys.nextActivity;
        "previous activity" = render keys.prevActivity;
        "show-on-mouse-pos" = render keys.clipboard;

        # Unbind conflicts
        "stop current activity" = "none";
      } // lib.genAttrs (map (n: "activate task manager entry ${toString n}") (lib.range 1 10)) (_: "none");

      # Application launch shortcuts
      "services/chromium-browser.desktop".new-window = render keys.browserAlt;

      "services/dev.zed.Zed.desktop".NewWorkspace = render keys.editor;

      "services/emacs.desktop"._launch = render keys.emacs;
      "services/emacsclient.desktop".new-window = render keys.emacsclient;

      "services/firefox.desktop" = {
        new-private-window = render keys.browserPrivate;
        new-window = render keys.browser;
        profile-manager-window = render keys.browserProfiles;
      };

      "services/com.mitchellh.ghostty.desktop".new-window = render keys.terminal;

      "services/org.kde.dolphin.desktop"._launch = render keys.files;
      "services/org.kde.krunner.desktop"._launch = render keys.launcher;
    };

    spectacle.shortcuts.launch = render keys.screenshot;
  };
}
