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

  # Provide a more complete sway environment
  sway = callOverride ./sway.nix {};

  # Add swayest workstyle
  sworkstyle = self.callPackage ./sworkstyle.nix {};

  # Fix tree sitter grammar abi incompatibility 
  tree-sitter-grammars = super.tree-sitter-grammars // {
    tree-sitter-python = super.tree-sitter-grammars.tree-sitter-python.overrideAttrs (_: {
      nativeBuildInputs = [ self.nodejs self.tree-sitter ];
      configurePhase = ''
        tree-sitter generate --abi 13 src/grammar.json
      '';
    });
  };

  # Custom firefox addons
  firefox-addons = super.firefox-addons // {
    tab-stash = super.callPackage ./tab-stash.nix {};
  };

  # Update zeal slightly
  zeal = callOverride ./zeal.nix {};
}
