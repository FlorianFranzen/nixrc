{
  description = "Home-Manager and NixOS configurations of Florian Franzen";

  inputs = {
    # Base packages and configurations
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Flake template library: layout -> outputs, update pipeline, cache
    ftl = {
      url = "github:FlorianFranzen/ftl";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Pull-based deployment of the base system
    comin = {
      url = "github:nlewo/comin/v0.14.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Hardware profiles
    hardware = {
      url = "github:NixOS/nixos-hardware";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Home management
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Secure boot support
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.1.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Nixified doom emacs distribution
    doom-emacs = {
      url = "github:marienz/nix-doom-emacs-unstraightened";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Additional kde config modules
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    # Firefox Addons
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Color scheme
    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # Layout (see the ftl README):
  #   pkgs/    own packages (<name>/package.nix), overlay.nix, config.nix
  #   nixos/   hosts/<name>/ (host.nix = metadata), modules/, profiles/, layers/
  #   home/    modules/, profiles/<dir>/, variants/ -> <base>-<variant>
  #   static/  wallpapers, doom config, keys (module argument `static`)
  outputs =
    {
      self,
      ftl,
      hardware,
      lanzaboote,
      catppuccin,
      comin,
      doom-emacs,
      plasma-manager,
      firefox-addons,
      ...
    }@inputs:
    ftl.lib.mkFlake {
      src = ./.;
      inherit inputs;
      name = "nixrc";
      repo = "github:FlorianFranzen/nixrc";

      # Applied before the local pkgs/ overlay
      overlays = [ firefox-addons.overlays.default ];

      nixos = {
        specialArgs.username = "florian";

        sharedModules = [
          lanzaboote.nixosModules.lanzaboote
          catppuccin.nixosModules.catppuccin
          comin.nixosModules.comin
        ];

        # Upstream hardware profiles, merged under nixos/profiles/hardware
        extraProfiles.hardware = hardware.nixosModules // {
          # Expose unstable upstream modules
          common-gpu-nvidia-kepler = "${hardware}/common/gpu/nvidia/kepler/default.nix";
        };

        # Inputs available via the registry and NIX_PATH on every host
        exportInputs = [
          "self"
          "nixpkgs"
          "home-manager"
        ];
      };

      home = {
        # Terminal base, plus light (sway) or full (KDE) desktop, each
        # combined with every theme in home/variants
        bases = {
          terminal = [ "terminal" ];
          desktop-light = [
            "terminal"
            "desktop"
            "desktop/light"
          ];
          desktop-full = [
            "terminal"
            "desktop"
            "desktop/full"
          ];
        };

        sharedModules = [
          doom-emacs.homeModule
          plasma-manager.homeModules.plasma-manager
          catppuccin.homeModules.catppuccin
        ];

        username = "florian";
      };

      # Installer images
      packages = {
        x86_64-linux.iso = self.nixosConfigurations.installer-x86_64.config.system.build.isoImage;
        aarch64-linux.iso = self.nixosConfigurations.installer-aarch64.config.system.build.isoImage;
      };
    };
}
