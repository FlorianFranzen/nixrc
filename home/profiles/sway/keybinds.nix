# Render the shared keybind set (home/modules/keybinds.nix) for sway
{ config, pkgs, lib, ... }:

let
  keys = config.keybinds;
  cfg = config.wayland.windowManager.sway.config;

  exec = pkg: exec' pkg pkg.pname;
  exec' = pkg: bin: "exec ${pkg}/bin/${bin}";

  browser = config.programs.firefox.package;

  thunar = pkgs.thunar.override {
    thunarPlugins = with pkgs; [
      thunar-archive-plugin
      thunar-vcs-plugin
      thunar-volman
    ];
  };

  WOBSOCK = "$XDG_RUNTIME_DIR/wob.sock";

  # KDE chord notation -> sway keysyms
  keysyms = {
    Meta = cfg.modifier;
    Backspace = "BackSpace";
    Del = "Delete";
    Space = "space";
    "[" = "bracketleft";
    "]" = "bracketright";
    "=" = "equal";
    "-" = "minus";
  };

  toSway = chord: lib.concatMapStringsSep "+" (part:
    keysyms.${part} or (if lib.stringLength part == 1 then lib.toLower part else part)
  ) (lib.splitString "+" chord);

  # action -> command, expanded to one entry per chord
  render = binds: lib.listToAttrs (lib.concatLists (lib.mapAttrsToList (action: command:
    map (chord: lib.nameValuePair (toSway chord) command) (lib.toList keys.${action})
  ) binds));

  perWorkspace = command: chords: lib.listToAttrs (lib.concatLists (lib.mapAttrsToList (n: chord:
    map (c: lib.nameValuePair (toSway c) "${command} ${n}") (lib.toList chord)
  ) chords));
in
{
  # Replace the sway defaults wholesale, the shared set is authoritative
  wayland.windowManager.sway.config.keybindings = lib.mkForce (
    render {
      # Session
      lock = exec' pkgs.swaylock-effects "swaylock";
      logout = "${exec pkgs.wlogout} -b 2";

      # Attention
      focusUrgent = "[urgent=latest] focus";

      # Window manipulation
      close = "kill";
      fullscreen = "fullscreen toggle";
      maximize = "layout toggle tabbed split";
      minimize = "move scratchpad";
      toggleFloat = "floating toggle";
      floatAll = "focus mode_toggle";
      opacityDown = "opacity minus 0.05";
      opacityUp = "opacity plus 0.05";

      # Focus and move
      focusLeft = "focus left";
      focusDown = "focus down";
      focusUp = "focus up";
      focusRight = "focus right";
      moveLeft = "move left";
      moveDown = "move down";
      moveUp = "move up";
      moveRight = "move right";

      # Tiling (no master slot in sway, setMaster stays unbound)
      grow = "resize grow width 10 px";
      shrink = "resize shrink width 10 px";
      nextLayout = "layout toggle split";
      prevLayout = "layout toggle tabbed stacking";
      rotate = "split toggle";
      rotatePart = "focus parent";

      # Window switching
      nextWindow = "focus next";
      prevWindow = "focus prev";
      nextWindowAlt = "focus next";
      prevWindowAlt = "focus prev";

      # Shell (no clipboard manager on sway, clipboard stays unbound)
      launcher = "exec ${cfg.menu}";
      screenshot = "${exec pkgs.sway-contrib.grimshot} --notify save area";

      # Applications
      terminal = "exec ${cfg.terminal}";
      emacs = "exec emacs";
      emacsclient = "exec emacsclient --create-frame";
      editor = "exec zeditor";
      browser = exec browser;
      browserPrivate = "${exec browser} --private-window";
      browserProfiles = "${exec browser} -P";
      browserAlt = "exec chromium";
      files = exec' thunar "thunar";
    }
    // perWorkspace "workspace number" keys.workspace
    // perWorkspace "move container to workspace number" keys.moveToWorkspace
    // {
      # Sway specific extras, kept off the shared chords
      "${cfg.modifier}+Shift+c" = "reload";
      "${cfg.modifier}+Shift+d" = "${exec pkgs.wofi} --show run";
      "${cfg.modifier}+Ctrl+r" = "mode resize";
      "${cfg.modifier}+Ctrl+m" = "mode mark";
      "${cfg.modifier}+Ctrl+t" = "mode switch";
      "${cfg.modifier}+Ctrl+b" = "splith";
      "${cfg.modifier}+Ctrl+v" = "splitv";
      "${cfg.modifier}+Shift+n" = "scratchpad show";
      "${cfg.modifier}+Print" = "${exec pkgs.sway-contrib.grimshot} --notify save window";

      # Fullscreen container in split parent
      "${cfg.modifier}+Shift+f" = "split v; focus parent; fullscreen toggle; focus child";

      # Move workspace between outputs
      "${cfg.modifier}+Ctrl+${cfg.left}" = "move workspace output left";
      "${cfg.modifier}+Ctrl+${cfg.down}" = "move workspace output down";
      "${cfg.modifier}+Ctrl+${cfg.up}" = "move workspace output up";
      "${cfg.modifier}+Ctrl+${cfg.right}" = "move workspace output right";

      "${cfg.modifier}+Ctrl+Left" = "move workspace output left";
      "${cfg.modifier}+Ctrl+Down" = "move workspace output down";
      "${cfg.modifier}+Ctrl+Up" = "move workspace output up";
      "${cfg.modifier}+Ctrl+Right" = "move workspace output right";

      # Volume control
      "--locked XF86AudioLowerVolume" = "${exec pkgs.pamixer} --decrease 5 --get-volume > ${WOBSOCK}";
      "--locked XF86AudioRaiseVolume" = "${exec pkgs.pamixer} --increase 5 --get-volume > ${WOBSOCK}";

      "--locked XF86AudioMute" = "${exec pkgs.pamixer} --toggle-mute";
      "--locked XF86AudioMicMute" = "${exec pkgs.pamixer} --default-source --toggle-mute";

      # Playback controls
      "--locked XF86AudioPrev" = "${exec pkgs.playerctl} previous";
      "--locked XF86AudioNext" = "${exec pkgs.playerctl} next";
      "--locked XF86AudioPlay" = "${exec pkgs.playerctl} play-pause";
      "--locked XF86AudioPause" = "${exec pkgs.playerctl} play-pause";
      "--locked XF86AudioStop" = "${exec pkgs.playerctl} stop";

      "--locked ${cfg.modifier}+XF86AudioPrev" = "${exec' pkgs.playerctl "playerctld"} unshift";
      "--locked ${cfg.modifier}+XF86AudioNext" = "${exec' pkgs.playerctl "playerctld"} shift";

      # Screen brightness controls
      "--locked XF86MonBrightnessUp" = "${exec pkgs.brightnessctl} s +10%";
      "--locked XF86MonBrightnessDown" = "${exec pkgs.brightnessctl} s 10%-";
    }
  );
}
