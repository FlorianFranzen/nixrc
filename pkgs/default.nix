self: super:

let
  lib = super.lib;

  callOverrideWith = pkgs: fn: args:
    let
      f = if lib.isFunction fn then fn else import fn;
      auto = builtins.intersectAttrs (lib.functionArgs f) pkgs;
    in f (auto // args);

  callOverride = callOverrideWith super;

in {
  # Support bbswitch on AMD CPUs
  linuxPackages_amd = super.linuxPackages_latest.extend (kself: ksuper: {
    bbswitch = callOverrideWith ksuper ./bbswitch.nix {};
  });

  # With experimental features
  bluez5-experimental = callOverride ./bluez.nix {};

  # Special version of bumblebee for AMD CPUs
  bumblebee_amd = callOverride ./bumblebee.nix {};

  iw = super.iw.overrideAttrs (old: rec {
    version = "5.19";
    name = "${old.pname}-${version}";

    src = super.fetchurl {
      url = "https://www.kernel.org/pub/software/network/${old.pname}/${old.pname}-${version}.tar.xz";
      sha256 = "sha256-8We76UfdU7uevAwdzvXbatc6wdYITyxvk3bFw2DMTU4=";
    };
  });

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

  # Custom firefox addons
  firefox-addons = super.firefox-addons // {
    tab-stash = super.callPackage ./tab-stash.nix {};
  };

  # Update zeal slightly
  zeal = callOverride ./zeal.nix {};
}
