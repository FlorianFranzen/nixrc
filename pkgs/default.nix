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
    ideapad-laptop = ksuper.callPackage ./ideapad-laptop.nix {}; 
    bbswitch = callOverrideWith ksuper ./bbswitch.nix {};
  });

  # Experimental hardware support
  linuxPackages = prev.linuxPackages.extend (kself: ksuper: {
    cxadc = ksuper.callPackage ./cxadc.nix {};
  });

  linuxPackages_latest = prev.linuxPackages_latest.extend (kself: ksuper: {
    atlantic = ksuper.callPackage ./atlantic.nix {};
  });

  linuxPackages_zen = prev.linuxPackages_zen.extend (kself: ksuper: {
    atlantic = ksuper.callPackage ./atlantic.nix {};
  });

  # Self-hosted AI workspace to be upstreamed
  odysseus = prev.callPackage ./odysseus.nix {};

  # Printer driver to be upstreamed
  cups-brother-mfcl2710dw = prev.callPackage ./cups-brother-mfcl2710dw.nix {};

  # Special version of bumblebee for AMD CPUs
  bumblebee_amd = callOverride ./bumblebee.nix {};

  # Focusrite Scarlett support
  fcp-support = final.callPackage ./fcp-support.nix {};

  # Command line tool to control monitor
  gbmonctl = final.callPackage ./gbmonctl.nix {};

  gruvbox-plus-icons = prev.gruvbox-plus-icons.overrideAttrs (_: {
    # Disable symlink check
    noBrokenSymlinksHookInstalled = true;
  });

  # input font but patched
  input-nerdfont = final.callPackage ./input-nerdfont.nix {};

  # Trick version detection in home manger to create valid config
  i3status-rust = prev.i3status-rust.overrideAttrs (old: {
    version = "0.30.0-fake${old.version}";
    __intentionallyOverridingVersion = true;
  });

  # Battery monitor for Framework led input modules
  led-battery-monitor = final.callPackage ./led-battery-monitor.nix {};

  # WSL boot shim maker
  mkSyschdemd = final.callPackage ./syschdemd.nix {};

  # Fix flaky openldap test
  openldap = prev.openldap.overrideAttrs {
    doCheck = !prev.stdenv.hostPlatform.isi686;
  };

  # Milkdrop Vizualizer with injected data
  projectm-sdl-cpp = callOverride ./projectm-sdl-cpp.nix {};

  # Add radicle link
  radicle-link = final.callPackage ./radicle-link.nix {};

  # Add rotki tracker
  rotki = final.callPackage ./rotki.nix {};

  # Provide a more complete sway environment
  sway = callOverride ./sway.nix {};

  # Open-source tonies server
  teddycloud = final.callPackage ./teddycloud.nix {};
  
  # MHL to MIDI converter
  traktor-kontrol = final.callPackage ./traktor-kontrol.nix {};

  # dbus integration for idle inhibiting
  wscreensaver-bridge = final.callPackage ./wscreensaver-bridge.nix {};
}
