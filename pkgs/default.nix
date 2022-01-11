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
    # Special version of bbswitch for amd cpus
    bbswitch = callOverrideWith ksuper ./bbswitch.nix {};
    # Latest version with some stability patches (incl in 5.16)
    rtw89 = callOverrideWith ksuper ./rtw89.nix {
      inherit (super) fetchFromGitHub;
    };
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
  linuxPackages = extendKernel super.linuxPackages;


  # With experimental features
  bluez5-experimental = callOverride ./bluez.nix {};

  # Patched to include git submodules
  nixFlakes = callOverride ./nix-flakes.nix {};

  # Patched to work with yubikey
  pam_ssh_agent_auth = callOverride ./pam_ssh_agent_auth.nix {};

  # Update to unreleased version with color fix
  swaylock-effects = callOverride ./swaylock-effects.nix {};

  # Simplify zsa device access
  zsa-udev-rules = callOverride ./zsa-udev-rules.nix {};


  # Wayland-backend for electron based apps
  element-desktop-wayland = enableOzoneWayland super.element-desktop;
  chromium-wayland = enableOzoneWayland super.chromium;
  signal-desktop-wayland = enableOzoneWayland super.signal-desktop;


  # Custom firefox addons
  firefox-addons = super.firefox-addons // { 
    polkadot-js = super.callPackage ./polkadot-js-extension.nix {}; 
  };
}
