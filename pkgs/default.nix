self: super:

let
  lib = super.lib;


  callOverrideWith = pkgs: fn: args:
    let
      f = if lib.isFunction fn then fn else import fn;
      auto = builtins.intersectAttrs (lib.functionArgs f) pkgs;
    in f (auto // args);

  callOverride = callOverrideWith super;


  extendKernel = kpkgs: kpkgs.extend (kself: ksuper: {
    # Special version of bbswitch for AMD CPUs
    bbswitch = callOverrideWith ksuper ./bbswitch.nix {};
  });


  enableOzoneWayland = drv: self.symlinkJoin {
    inherit (drv) name version meta;
    nativeBuildInputs = [ self.makeWrapper ];
    paths = [ drv ];

    postBuild = ''
      for bin in $out/bin/*; do
        echo "- wrapping $bin..."
        wrapProgram "$bin" \
          --add-flags "--enable-features=UseOzonePlatform,WebRTCPipeWireCapturer --ozone-platform=wayland --gtk-version=4"
      done
    '';
  };
in {
  # Kernel module overrides
  linuxPackages_latest = extendKernel super.linuxPackages_latest;

  # With experimental features
  bluez5-experimental = callOverride ./bluez.nix {};

  # Special version of bbswitch AMD CPUs
  bumblebee = callOverride ./bumblebee.nix {};

  # WSL boot shim maker
  mkSyschdemd = self.callPackage ./syschdemd.nix {};

  # Patched to include git submodules
  nixSubmodule = callOverride ./nix-submodule.nix {};

  # Patched to work with yubikey
  pam_ssh_agent_auth = callOverride ./pam_ssh_agent_auth.nix {};

  # Add rotki tracker
  rotki = self.callPackage ./rotki.nix {};

  # Update to unreleased version with color fix
  swaylock-effects = callOverride ./swaylock-effects.nix {};

  # Add swayest workstyle
  sworkstyle = self.callPackage ./sworkstyle.nix {};

  # Simplify zsa device access
  zsa-udev-rules = callOverride ./zsa-udev-rules.nix {};

  # Wayland-backend for electron based apps
  chromium-wayland = enableOzoneWayland super.chromium;
  signal-desktop-wayland = enableOzoneWayland super.signal-desktop;

  # Custom firefox addons
  firefox-addons = super.firefox-addons // {
    tab-stash = super.callPackage ./tab-stash.nix {};
  };
}
