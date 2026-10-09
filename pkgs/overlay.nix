# Overrides of existing packages and everything that is not a plain
# top-level package. Plain packages live in <name>/package.nix and are added
# by ftl before this overlay is applied.
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
  linuxPackages_amd = prev.linuxPackages_6_12.extend (kself: ksuper: {
    ideapad-laptop = ksuper.callPackage ./linux-modules/ideapad-laptop/package.nix {}; 
    bbswitch = callOverrideWith ksuper ./linux-modules/bbswitch/package.nix {};
  });

  # Experimental hardware support
  linuxPackages = prev.linuxPackages.extend (kself: ksuper: {
    cxadc = ksuper.callPackage ./linux-modules/cxadc/package.nix {};
  });

  linuxPackages_latest = prev.linuxPackages_latest.extend (kself: ksuper: {
    atlantic = ksuper.callPackage ./linux-modules/atlantic/package.nix {};
  });

  linuxPackages_zen = prev.linuxPackages_zen.extend (kself: ksuper: {
    atlantic = ksuper.callPackage ./linux-modules/atlantic/package.nix {};
  });

  # Special version of bumblebee for AMD CPUs
  bumblebee_amd = callOverride ./overrides/bumblebee.nix {};

  gruvbox-plus-icons = prev.gruvbox-plus-icons.overrideAttrs (_: {
    # Disable symlink check
    noBrokenSymlinksHookInstalled = true;
  });

  # Trick version detection in home manger to create valid config
  i3status-rust = prev.i3status-rust.overrideAttrs (old: {
    version = "0.30.0-fake${old.version}";
    __intentionallyOverridingVersion = true;
  });

  # Fix flaky openldap test
  openldap = prev.openldap.overrideAttrs {
    doCheck = !prev.stdenv.hostPlatform.isi686;
  };

  # Milkdrop Vizualizer with injected data
  projectm-sdl-cpp = callOverride ./overrides/projectm-sdl-cpp.nix {};

  # Provide a more complete sway environment
  sway = callOverride ./overrides/sway.nix {};

  

}
