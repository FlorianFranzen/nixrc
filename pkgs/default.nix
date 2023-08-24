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
  linuxPackages_amd = prev.linuxPackages_latest.extend (kself: ksuper: {
    ideapad-laptop = ksuper.callPackage ./ideapad-laptop.nix {}; 
    bbswitch = callOverrideWith ksuper ./bbswitch.nix {};
  });

  # Support latest asus mainboard monitoring
  linuxPackages_latest = prev.linuxPackages_latest.extend (kself: ksuper: {
    nct6775 = ksuper.callPackage ./nct6775.nix {};
  });

  # Special version of bumblebee for AMD CPUs
  bumblebee_amd = callOverride ./bumblebee.nix {};

  # WSL boot shim maker
  mkSyschdemd = final.callPackage ./syschdemd.nix {};

  # Patched to include git submodules
  nixSubmodule = callOverride ./nix-submodule.nix {};

  # Patched to work with yubikey
  #pam_ssh_agent_auth = callOverride ./pam_ssh_agent_auth.nix {};

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

  # Custom firefox addons
  firefox-addons = prev.firefox-addons // {
    tab-stash = prev.callPackage ./tab-stash.nix {};
  };

  # Update zeal slightly
  zeal-qt6 = callOverride ./zeal.nix {};

  # Force zoom to run on x11
  zoom-us = callOverride ./zoom-us.nix {};
}
