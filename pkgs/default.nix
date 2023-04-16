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

  # Provide some sane sway environment
  sway = super.sway.override {
    extraOptions = [ "--unsupported-gpu" ];

    extraSessionCommands = let
      schema = self.gsettings-desktop-schemas;
      datadir = "${schema}/share/gsettings-schemas/${schema.name}";
    in ''
      # Enable libappindicator support
      export XDG_CURRENT_DESKTOP=sway

      # Enable wayland backends
      export XDG_SESSION_TYPE=wayland

      # Use CLUTTER wayland backend
      export CLUTTER_BACKEND=wayland

      # Enable mozilla wayland backend
      export MOZ_ENABLE_WAYLAND=1

      # Enable smooth scrolling
      export MOZ_USE_XINPUT2=1

      # Enable mozilla dbus
      export MOZ_DBUS_REMOTE=1

      # Enable LibreOffice gtk3 backend
      export SAL_USE_VCLPLUGIN=gtk3

      # Configure Qt wayland backend
      export QT_QPA_PLATFORM=wayland
      export QT_AUTO_SCREEN_SCALE_FACTOR=1
      export QT_WAYLAND_FORCE_DPI=physical
      export QT_WAYLAND_DISABLE_WINDOWDECORATION=1

      # Configure ozone backend for chromium apps
      export NIXOS_OZONE_WL=1

      # Configure SDL wayland backend
      export SDL_VIDEODRIVER=wayland

      # Fix Java AWT applications
      export _JAVA_AWT_WM_NONREPARENTING=1

      # Use GTK theme and integration
      export DESKTOP_SESSION=gnome
      export QT_QPA_PLATFORMTHEME=gtk2

      # Use GTK portal if possible
      export GTK_USE_PORTAL=1

      # Set WLRoots renderer to Vulkan to avoid flickering
      export WLR_RENDERER=vulkan

      # Fix gsettings
      export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
    '';

    withBaseWrapper = true;
    withGtkWrapper = true;
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

  waydroid = super.callPackage ./waydroid.nix {};

  # Update zeal slightly
  zeal = callOverride ./zeal.nix {};
}
