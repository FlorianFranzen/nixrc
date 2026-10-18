# One semantic set of desktop keybinds, rendered by each stack
# (kde/keybinds.nix, sway/keybinds.nix, ...) into its own syntax.
#
# Chords use KDE notation: "Meta+Shift+H". Shift+digit is written as
# "Meta+Shift+1", never as "Meta+!". A list binds several chords.
{ lib, ... }:

let
  chord = with lib.types; either str (listOf str);

  digits = map toString (lib.range 1 9);

  # Default chords, taken from the KDE setup
  defaults = {
    # Session
    lock = "Meta+O";
    logout = "Meta+Shift+Q";

    # Overviews and attention
    focusUrgent = "Meta+S";
    overview = "Meta+G";
    overviewAll = "Meta+Ctrl+G";
    overviewClass = "Meta+Shift+G";

    # Window manipulation
    close = "Meta+Q";
    fullscreen = "Meta+F";
    maximize = "Meta+M";
    minimize = "Meta+N";
    windowMenu = "Meta+B";
    toggleFloat = "Meta+Space";
    floatAll = "Meta+Shift+Space";
    opacityDown = "Meta+[";
    opacityUp = "Meta+]";

    # Focus and move
    focusLeft = [ "Meta+H" "Meta+Left" ];
    focusDown = [ "Meta+J" "Meta+Down" ];
    focusUp = [ "Meta+K" "Meta+Up" ];
    focusRight = [ "Meta+L" "Meta+Right" ];
    moveLeft = [ "Meta+Shift+H" "Meta+Shift+Left" ];
    moveDown = [ "Meta+Shift+J" "Meta+Shift+Down" ];
    moveUp = [ "Meta+Shift+K" "Meta+Shift+Up" ];
    moveRight = [ "Meta+Shift+L" "Meta+Shift+Right" ];

    # Tiling
    grow = "Meta+I";
    shrink = "Meta+Shift+I";
    nextLayout = "Meta+E";
    prevLayout = "Meta+W";
    rotate = "Meta+R";
    rotatePart = "Meta+Shift+R";
    setMaster = "Meta+T";

    # Window switching
    nextWindow = "Meta+Tab";
    prevWindow = "Meta+Shift+Tab";
    nextWindowAlt = "Alt+Tab";
    prevWindowAlt = "Alt+Shift+Tab";

    # Zoom and activities
    zoomReset = "Meta+0";
    zoomIn = "Meta+=";
    zoomOut = "Meta+-";
    nextActivity = "Meta+A";
    prevActivity = "Meta+Shift+A";

    # Shell panels
    launcher = "Meta+D";
    clipboard = "Meta+V";
    screenshot = "Meta+P";

    # Applications
    terminal = "Meta+Return";
    emacs = "Meta+Shift+Return";
    emacsclient = "Meta+Alt+Return";
    editor = "Meta+Ctrl+Return";
    browser = "Meta+Backspace";
    browserPrivate = "Meta+Shift+Backspace";
    browserProfiles = "Meta+Alt+Backspace";
    browserAlt = "Meta+Ctrl+Backspace";
    files = "Meta+Del";
  };
in
{
  options.keybinds = lib.mapAttrs (name: default: lib.mkOption {
    type = chord;
    inherit default;
    description = "Chord(s) for the ${name} action.";
  }) defaults // {
    workspace = lib.mkOption {
      type = lib.types.attrsOf chord;
      default = lib.genAttrs digits (n: "Meta+${n}");
      description = "Chords to switch to a workspace, by number.";
    };

    moveToWorkspace = lib.mkOption {
      type = lib.types.attrsOf chord;
      default = lib.genAttrs digits (n: "Meta+Shift+${n}");
      description = "Chords to move the focused window to a workspace, by number.";
    };
  };
}
