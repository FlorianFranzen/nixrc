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
    ideapad-laptop = ksuper.callPackage ./ideapad-laptop.nix {}; 
    bbswitch = callOverrideWith ksuper ./bbswitch.nix {};
  });

  # With experimental features
  bluez5-experimental = callOverride ./bluez.nix {};

  # Special version of bumblebee for AMD CPUs
  bumblebee_amd = callOverride ./bumblebee.nix {};

  # WSL boot shim maker
  mkSyschdemd = self.callPackage ./syschdemd.nix {};

  # Patched to include git submodules
  nixSubmodule = callOverride ./nix-submodule.nix {};

  # Patched to work with yubikey
  pam_ssh_agent_auth = callOverride ./pam_ssh_agent_auth.nix {};

  # Add radicle link
  radicle-link = self.callPackage ./radicle-link.nix {};

  # Add rotki tracker
  rotki = self.callPackage ./rotki.nix {};

  # Add swayest workstyle
  sworkstyle = self.callPackage ./sworkstyle.nix {};

  # Custom firefox addons
  firefox-addons = super.firefox-addons // {
    tab-stash = super.callPackage ./tab-stash.nix {};
  };

  waydroid = super.callPackage ./waydroid.nix {};

  # Update zeal slightly
  zeal = callOverride ./zeal.nix {};
}
