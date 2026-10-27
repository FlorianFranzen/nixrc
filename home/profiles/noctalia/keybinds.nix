# Render the shared keybind set (home/modules/keybinds.nix) for umbriel
{ config, pkgs, lib, ... }:

let
  keys = config.keybinds;

  browser = config.programs.firefox.package;

  thunar = pkgs.thunar.override {
    thunarPlugins = with pkgs; [
      thunar-archive-plugin
      thunar-vcs-plugin
      thunar-volman
    ];
  };

  msg = cmd: "spawn:noctalia msg ${cmd}";

  # KDE chord notation -> umbriel keysyms
  keysyms = {
    Meta = "Mod";
    Backspace = "BackSpace";
    Del = "Delete";
    Space = "space";
    "[" = "bracketleft";
    "]" = "bracketright";
    "=" = "equal";
    "-" = "minus";
  };

  toUmbriel = chord: lib.concatMapStringsSep "+" (part: keysyms.${part} or part) (lib.splitString "+" chord);

  # action -> command, expanded to one entry per chord
  render = binds: lib.listToAttrs (lib.concatLists (lib.mapAttrsToList (action: command:
    map (chord: lib.nameValuePair (toUmbriel chord) command) (lib.toList keys.${action})
  ) binds));

  perWorkspace = command: chords: lib.listToAttrs (lib.concatLists (lib.mapAttrsToList (n: chord:
    map (c: lib.nameValuePair (toUmbriel c) "${command}:${n}") (lib.toList chord)
  ) chords));

  locked = action: { inherit action; allow_when_locked = true; };
in
{
  home.packages = [ thunar ];

  wayland.umbriel.keybinds =
    render {
      # Session
      lock = msg "session lock";
      logout = msg "panel-toggle session";

      # Attention and overview
      focusUrgent = msg "panel-toggle control-center";
      overview = "overview-toggle";

      # Window manipulation
      close = "window-close";
      fullscreen = "window-toggle-fullscreen";
      maximize = "window-toggle-maximize";
      minimize = "window-move-to-scratchpad";
      toggleFloat = "window-toggle-floating";
      floatAll = "window-focus-switch-floating";

      # Focus and move
      focusLeft = "window-focus-or-output-left";
      focusDown = "window-focus-or-output-down";
      focusUp = "window-focus-or-output-up";
      focusRight = "window-focus-or-output-right";
      moveLeft = "window-move-or-output-left";
      moveDown = "window-move-or-output-down";
      moveUp = "window-move-or-output-up";
      moveRight = "window-move-or-output-right";

      # Tiling
      grow = "window-modify-width-right:0.1";
      shrink = "window-modify-width-right:-0.1";
      nextLayout = "workspace-set-layout:toggle";
      prevLayout = "window-cycle-primary-extent-back";
      rotate = "window-cycle-primary-extent";
      rotatePart = "window-cycle-secondary-extent";
      setMaster = "column-move-to-first";

      # Window switching
      nextWindow = "window-focus-next";
      prevWindow = "window-focus-previous";
      nextWindowAlt = msg "window-switcher";
      prevWindowAlt = "window-focus-last";

      # Shell panels
      launcher = msg "panel-toggle launcher";
      clipboard = msg "panel-toggle clipboard";
      screenshot = msg "screenshot-region";

      # Applications
      terminal = "spawn:ghostty";
      emacs = "spawn:emacs";
      emacsclient = "spawn:emacsclient --create-frame";
      editor = "spawn:zeditor";
      browser = "spawn:${browser}/bin/firefox";
      browserPrivate = "spawn:${browser}/bin/firefox --private-window";
      browserProfiles = "spawn:${browser}/bin/firefox -P";
      browserAlt = "spawn:chromium";
      files = "spawn:${thunar}/bin/thunar";
    }
    // perWorkspace "workspace-switch" keys.workspace
    // perWorkspace "window-move-to-workspace" keys.moveToWorkspace
    // {
      # Umbriel specific extras, kept off the shared chords
      "Mod+comma" = msg "settings-toggle";
      "Mod+Shift+N" = "scratchpad-toggle";
      "Mod+Print" = msg "screenshot-fullscreen";
      "Mod+Shift+Print" = msg "screenshot-annotate";
      "Mod+Ctrl+Q" = "session-quit";

      # Move column between outputs
      "Mod+Ctrl+H" = "column-move-to-output-left";
      "Mod+Ctrl+J" = "column-move-to-output-down";
      "Mod+Ctrl+K" = "column-move-to-output-up";
      "Mod+Ctrl+L" = "column-move-to-output-right";
      "Mod+Ctrl+Left" = "column-move-to-output-left";
      "Mod+Ctrl+Down" = "column-move-to-output-down";
      "Mod+Ctrl+Up" = "column-move-to-output-up";
      "Mod+Ctrl+Right" = "column-move-to-output-right";

      # Volume control
      "XF86AudioLowerVolume" = locked (msg "volume-down");
      "XF86AudioRaiseVolume" = locked (msg "volume-up");
      "XF86AudioMute" = locked (msg "volume-mute");
      "XF86AudioMicMute" = locked "spawn:${pkgs.pamixer}/bin/pamixer --default-source --toggle-mute";

      # Playback controls
      "XF86AudioPrev" = locked "spawn:${pkgs.playerctl}/bin/playerctl previous";
      "XF86AudioNext" = locked "spawn:${pkgs.playerctl}/bin/playerctl next";
      "XF86AudioPlay" = locked "spawn:${pkgs.playerctl}/bin/playerctl play-pause";
      "XF86AudioPause" = locked "spawn:${pkgs.playerctl}/bin/playerctl play-pause";
      "XF86AudioStop" = locked "spawn:${pkgs.playerctl}/bin/playerctl stop";
      "Mod+XF86AudioPrev" = locked "spawn:${pkgs.playerctl}/bin/playerctld unshift";
      "Mod+XF86AudioNext" = locked "spawn:${pkgs.playerctl}/bin/playerctld shift";

      # Screen brightness controls
      "XF86MonBrightnessUp" = locked (msg "brightness-up");
      "XF86MonBrightnessDown" = locked (msg "brightness-down");
    };
}
