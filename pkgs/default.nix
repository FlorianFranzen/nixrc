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
  # Support bbswitch on AMD CPUs
  linuxPackages_amd = prev.linuxPackages.extend (kself: ksuper: {
    ideapad-laptop = ksuper.callPackage ./ideapad-laptop.nix {}; 
    bbswitch = callOverrideWith ksuper ./bbswitch.nix {};
  });

  # Support latest asus mainboard monitoring
  linuxPackages_latest = prev.linuxPackages_latest.extend (kself: ksuper: {
    nct6775 = ksuper.callPackage ./nct6775.nix {};
  });

  # Printer driver to be upstreamed
  cups-brother-mfcl2710dw = prev.callPackage ./cups-brother-mfcl2710dw.nix {};

  # Special version of bumblebee for AMD CPUs
  bumblebee_amd = callOverride ./bumblebee.nix {};

  # Temporary fix to be merged upstream
  bluez5-experimental = prev.bluez5-experimental.overrideAttrs (old: rec {
    version = "5.72";

    src = prev.fetchurl {
      url = "mirror://kernel/linux/bluetooth/bluez-${version}.tar.xz";
      hash = "sha256-SZ1/o0WplsG7ZQ9cZ0nh2SkRH6bs4L4OmGh/7mEkU24=";
    };

    nativeBuildInputs = old.nativeBuildInputs ++ [ prev.python3.pkgs.pygments ];
  });

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
  };

  # Add swayest workstyle
  sworkstyle = final.callPackage ./sworkstyle.nix {};

  # Fix udev rules
  wooting-udev-rules = prev.wooting-udev-rules.overrideAttrs (_: {
    src = [ ./wooting.rules ];
  });

  # Update zeal slightly
  zeal-qt6 = callOverride ./zeal.nix {};
}
