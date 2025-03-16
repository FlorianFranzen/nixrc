final: prev:

let
  lib = prev.lib;

  callOverrideWith = pkgs: fn: args:
    let
      f = if lib.isFunction fn then fn else import fn;
      auto = builtins.intersectAttrs (lib.functionArgs f) pkgs;
    in f (auto // args);

  callOverride = callOverrideWith prev; 

in {
  # Support bbswitch on AMD CPUs on recent kernel
  # Speaker support seems to become broken somewhere between 6.2 and 6.6  
  linuxPackages_amd = prev.linuxPackages_6_11.extend (kself: ksuper: {
    ideapad-laptop = ksuper.callPackage ./ideapad-laptop.nix {}; 
    bbswitch = callOverrideWith ksuper ./bbswitch.nix {};
  });

  # Experimental hardware support
  linuxPackages = prev.linuxPackages.extend (kself: ksuper: {
    cxadc = ksuper.callPackage ./cxadc.nix {};
  });

  # Printer driver to be upstreamed
  cups-brother-mfcl2710dw = prev.callPackage ./cups-brother-mfcl2710dw.nix {};

  # Special version of bumblebee for AMD CPUs
  bumblebee_amd = callOverride ./bumblebee.nix {};

  gruvbox-plus-icons = prev.gruvbox-plus-icons.overrideAttrs (_: {
    # Disable symlink check
    noBrokenSymlinksHookInstalled = true;
  });

  # Tiling engine for Kwin 6
  krohnkite = final.callPackage ./krohnkite.nix {};

  # WSL boot shim maker
  mkSyschdemd = final.callPackage ./syschdemd.nix {};

  # Patched to include git submodules
  nixSubmodule = callOverride ./nix-submodule.nix {};

  # Milkdrop Vizualizer
  projectM-sdl2 = final.callPackage ./projectM-sdl2.nix {
    libprojectM = final.callPackage ./libprojectM.nix {};
  };

  # Qt6 theming plugin
  qt6gtk2 = final.qt6Packages.callPackage ./qt6gtk2.nix {};

  # Add radicle link
  radicle-link = final.callPackage ./radicle-link.nix {};

  retroarch = prev.retroarch.override {
    cores = with final.libretro; [ mupen64plus dolphin ];
  };

  # Add rotki tracker
  rotki = final.callPackage ./rotki.nix {};

  # Provide a more complete sway environment
  sway = callOverride ./sway.nix {};

  sway-nvidia = callOverride ./sway.nix { withNvidia = true; };

  # Add swayest workstyle
  sworkstyle = final.callPackage ./sworkstyle.nix {};

  # MHL to MIDI converter
  traktor-kontrol = final.callPackage ./traktor-kontrol.nix {};

  # joypad idle inhibition
  wljoywake = final.callPackage ./wljoywake.nix {};

  # Fix udev rules
  wooting-udev-rules = prev.wooting-udev-rules.overrideAttrs (_: {
    src = [ ./wooting.rules ];
  });

  # dbus integration for idle inhibiting
  wscreensaver-bridge = final.callPackage ./wscreensaver-bridge.nix {};

  # ...
  suyu = final.qt6.callPackage ./suyu.nix {
    compat-list = final.callPackage ./suyu.compat-list.nix {};
    nx_tzdb = final.callPackage ./suyu.nx_tzdb.nix {};
  };

  # ...
  teddycloud = final.callPackage ./teddycloud.nix {};

  # Fix backend used (and screensharing)
  zoom-us = prev.runCommand "zoom-wayland" {} ''
    source ${prev.dieHook}/nix-support/setup-hook
    source ${prev.makeWrapper}/nix-support/setup-hook
    makeWrapper ${prev.zoom-us}/bin/zoom $out/bin/zoom --set XDG_CURRENT_DESKTOP gnome
    cp -r ${prev.zoom-us}/share $out/share
    chmod +w $out/share/applications/Zoom.desktop
    sed "s@${prev.zoom-us}@$out@" ${prev.zoom-us}/share/applications/Zoom.desktop > $out/share/applications/Zoom.desktop
  '';
}
