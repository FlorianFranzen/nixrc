self: super:

let
  lib = super.lib;

  callOverrideWith = pkgs: fn: args:
    let
      f = if lib.isFunction fn then fn else import fn;
      auto = builtins.intersectAttrs (lib.functionArgs f) pkgs;
    in f (auto // args);

  callOverride = callOverrideWith super; 

  # Internal packages not exported
  wlroots-nvidia = (self.callPackage
    "${self.path}/pkgs/applications/window-managers/hyprwm/hyprland/wlroots.nix" { nvidiaPatches = true; }
  ).overrideAttrs (old: {
    src = self.fetchFromGitLab {
      domain = "gitlab.freedesktop.org";
      owner = "wlroots";
      repo = "wlroots";
      rev = "15f2f6642fb5020c1b69e5424a8463569ea6a3e9";
      hash = "sha256-XC+Qks62cOLtkpO6es1XH7WZ/jBbf0uwWhMBz3GwmLA=";
    };

    #patches = old.patches ++ [ ./wlroots.swcursor.patch ];
  });

  sway-unwrapped-nvidia = (self.sway-unwrapped.override { 
    wlroots = wlroots-nvidia;
  }).overrideAttrs (old: {
    pname = "${old.pname}-nvidia";
    version = "2023-01-16+tray";

    src = self.fetchFromGitHub {
      owner = "FlorianFranzen";
      repo = "sway";
      rev = "feature/tray-dbus-menu";
      hash = "sha256-I6KRGt2XHYWhxP5Q1GUNlSeYVINKTqFa9dvasDgdGPg=";
    };

    patches = let 
      target = "/nix/store/bvxqmqg6pxninhds3padj7ilp9qs3ykm-LIBINPUT_CONFIG_ACCEL_PROFILE_CUSTOM.patch";
      patchFilter = p: (p.outPath or p) != target;
    in builtins.filter patchFilter old.patches; 
  });
in {
  # Support bbswitch on AMD CPUs
  linuxPackages_amd = super.linuxPackages_latest.extend (kself: ksuper: {
    ideapad-laptop = ksuper.callPackage ./ideapad-laptop.nix {}; 
    bbswitch = callOverrideWith ksuper ./bbswitch.nix {};
  });

  # Support latest asus mainboard monitoring
  linuxPackages_latest = super.linuxPackages_latest.extend (kself: ksuper: {
    nct6775 = ksuper.callPackage ./nct6775.nix {};
  });

  # Special version of bumblebee for AMD CPUs
  bumblebee_amd = callOverride ./bumblebee.nix {};

  # WSL boot shim maker
  mkSyschdemd = self.callPackage ./syschdemd.nix {};

  # Patched to include git submodules
  nixSubmodule = callOverride ./nix-submodule.nix {};

  # Patched to work with yubikey
  #pam_ssh_agent_auth = callOverride ./pam_ssh_agent_auth.nix {};

  # Qt6 theming plugin
  qt6gtk2 = self.qt6Packages.callPackage ./qt6gtk2.nix {};

  # Add radicle link
  radicle-link = self.callPackage ./radicle-link.nix {};

  # Add rotki tracker
  rotki = self.callPackage ./rotki.nix {};

  # Provide a more complete sway environment
  sway = callOverride ./sway.nix {};

  sway-nvidia = callOverride ./sway.nix { 
    sway-unwrapped = sway-unwrapped-nvidia;
    withNvidia = true;
  };

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
  zeal-qt6 = callOverride ./zeal.nix {};

  # Force zoom to run on x11
  zoom-us = callOverride ./zoom-us.nix {};
}
