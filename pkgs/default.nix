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
  linuxPackages_amd = prev.linuxPackages_6_8.extend (kself: ksuper: {
    ideapad-laptop = ksuper.callPackage ./ideapad-laptop.nix {}; 
    bbswitch = callOverrideWith ksuper ./bbswitch.nix {};
  });

  # Printer driver to be upstreamed
  cups-brother-mfcl2710dw = prev.callPackage ./cups-brother-mfcl2710dw.nix {};

  # Special version of bumblebee for AMD CPUs
  bumblebee_amd = callOverride ./bumblebee.nix {};

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

  # Add rotki tracker
  rotki = final.callPackage ./rotki.nix {};

  # Provide a more complete sway environment
  sway = callOverride ./sway.nix {};

  sway-nvidia = callOverride ./sway.nix {
    withNvidia = true;

    # Patched wlroots to fix flickering
    wlroots = prev.wlroots.overrideAttrs (old: {
      patches = old.patches ++ [
        ./wlroots.nvidia.patch
      ];
    });
  };

  # Add swayest workstyle
  sworkstyle = final.callPackage ./sworkstyle.nix {};

  # joypad idle inhibition
  wljoywake = final.callPackage ./wljoywake.nix {};

  # Fix udev rules
  wooting-udev-rules = prev.wooting-udev-rules.overrideAttrs (_: {
    src = [ ./wooting.rules ];
  });

  # dbus integration for idle inhibiting
  wscreensaver-bridge = final.callPackage ./wscreensaver-bridge.nix {};

  # ...
  yuzu = final.qt6.callPackage ./yuzu.nix {
    compat-list = final.callPackage ./yuzu.compat-list.nix {};
    nx_tzdb = final.callPackage ./yuzu.nx_tzdb.nix {};
  };

  # Update zeal slightly
  zeal-qt6 = callOverride ./zeal.nix {};
}
