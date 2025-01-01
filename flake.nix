{
  description = "Home-Manager and NixOS configurations of Florian Franzen";

  inputs = {
    # Nix Import helper
    haumea = {
      url = "github:nix-community/haumea/v0.2.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Base packages and configurations
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Hardware profiles
    hardware.url = "github:NixOS/nixos-hardware";

    # Secure boot support
    lanzaboote = {
      url = "github:FlorianFranzen/lanzaboote/v0.4.1-mirror";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Home management 
    home-manager = {
      url = "github:nix-community/home-manager";
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
  };

  outputs = {
    self,
    haumea,
    nixpkgs,
    hardware,
    lanzaboote,
    home-manager,
    plasma-manager,
    firefox-addons,
  } @ inputs: let

    # Bring some useful builtins and nixpkgs lib helpers into scope
    inherit (builtins) attrNames attrValues filter foldl' mapAttrs isAttrs;

    inherit (nixpkgs.lib) filterAttrs genAttrs mapAttrs' recursiveUpdate;

    # List supported systems (no darwin or 32bit linux support)
    supportedSystems = [ "aarch64-linux" "x86_64-linux" ];

    # Main user name to use in system and home-manager outputs
    username = "florian";

    # Turn firefox addons collection to overlay
    firefox-addons-overlay = (final: prev: {
      buildFirefoxXpiAddon = firefox-addons.lib.${prev.system}.buildFirefoxXpiAddon;
      firefox-addons = firefox-addons.packages.${prev.system};
    });

    # Provide default list of overlays
    overlays = [
      firefox-addons-overlay
      self.overlays.default
    ];

    # Initialize one package collection per system
    pkgs = genAttrs supportedSystems (system: import nixpkgs {
      inherit overlays system;
    });

    # Output all attributes added via overlay as packages
    overlayPackages = let
      names = attrNames (self.overlays.default {} {});
    in genAttrs supportedSystems (system:
      genAttrs names (name: pkgs.${system}.${name})
    );

    # Import all nixos profiles, modules and host configs as paths
    nixos = haumea.lib.load {
      src = ./nixos;
      loader = haumea.lib.loaders.path;
    };

    # Import all home profiles, modules and configs as paths
    homes = haumea.lib.load {
      src = ./homes;
      loader = haumea.lib.loaders.path;
    };

    # Combination of upstream and custom hardware-based profiles
    hardwareProfiles = hardware.nixosModules // self.nixosProfiles.hardware // {
      # Expose unstable upstream modules
      common-gpu-nvidia-kepler = "${hardware}/common/gpu/nvidia/kepler/default.nix";
    };

    # All external and custom home modules
    homeModules = [
      plasma-manager.homeManagerModules.plasma-manager
    ] ++ attrValues self.homeModules;

    # Helpers to parse home directory structure:
    #  - homes/terminal  default base config
    #  - homes/desktop   default desktop environment
    #  - homes/variants  variants, themes, special environments
    homeVariants = let
      # Create a module for specified username and imports
      mkModule = imports: {lib, ...}: {
        inherit imports;

        # Add portable defaults for use outside of NixOS
        home = {
          username = lib.mkDefault username;
          homeDirectory = lib.mkDefault "/home/${username}";
        };
      };

      # Base config for basic terminal integration
      terminal-modules = attrValues homes.terminal;

      terminals = mapAttrs' (name: config: {
          name = "terminal-${name}";
          value = mkModule (terminal-modules ++ [ config ]);
        }) homes.variants;

      # Fancier config for full desktop environment
      desktop-base = attrValues (filterAttrs (n: _: n != "light" && n != "full") homes.desktop);

      # Split into base, light and full
      desktop-light = attrValues homes.desktop.light;
      desktop-full = attrValues homes.desktop.full;

      # Combine base either light or full for complete config
      desktops-light = mapAttrs' (name: config: {
          name = "desktop-light-${name}";
          value = mkModule (terminal-modules ++ desktop-base ++ desktop-light ++ [ config ]);
        }) homes.variants;

      desktops-full = mapAttrs' (name: config: {
          name = "desktop-full-${name}";
          value = mkModule (terminal-modules ++ desktop-base ++ desktop-full ++ [ config ]);
        }) homes.variants;

    in (terminals // desktops-light // desktops-full);

    # Various assets used in home config
    homeAssets = {
      # Some wallpapers to be used in theming
      wallpaper-astronaut-gruvbox = ./homes/assets/astronaut-gruvbox.jpg;
      wallpaper-nixish-dark = ./homes/assets/nixish-dark.png;
      wallpaper-snowflake-solarized = ./homes/assets/snowflake-solarized.png;
      wallpaper-mojave-dark = ./homes/assets/mojave-dark.jpg;
    };

    # Output each system toplevel build as a check
    nixosChecks = mapAttrs' (name: config: {
      name = "nixos-${name}";
      value = config.config.system.build.toplevel;
    }) self.nixosConfigurations;

    # Output each home activation package as a check
    homeChecks = mapAttrs' (name: config: {
      name = "home-${name}";
      value = config.activationPackage;
    }) self.homeConfigurations;

  in {
    # All nix files under nixos/modules
    nixosModules = nixos.modules;

    # All nix files under nixos/profiles
    nixosProfiles = nixos.profiles;

    # For each set of modules under nixos/hosts/<hostname>
    nixosConfigurations = mapAttrs
      (name: configs:
        nixpkgs.lib.nixosSystem {
          # Assemble modules
          modules = [
              # Additional upstream modules
              lanzaboote.nixosModules.lanzaboote
              home-manager.nixosModules.home-manager
              # Module for various flake integration
              ({ lib,... }: {
                # Apply overlays with priority
                nixpkgs.overlays = lib.mkBefore overlays;

                # Set flake based properties
                networking.hostName = name;
                system.configurationRevision = lib.mkIf (self ? rev) self.rev;

                # Provide backward compatibility
                nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

                # Undo weird upstream "fix"
                nix.settings.nix-path = "nixpkgs=${inputs.nixpkgs}";

                # Provide certain inputs via the registry
                nix.registry = lib.genAttrs
                  ["self" "nixpkgs" "home-manager"]
                  (name: { flake = inputs.${name}; });

                # Configure home-manager module
                home-manager = {
                  # Automatically backup instead of error
                  backupFileExtension = "conflict";

                  # Full integrate with NixOS
                  useGlobalPkgs = true;
                  useUserPackages = true;

                  # External and shared modules in homes/modules
                  sharedModules = homeModules;

                  # Provide profiles as additional module inputs
                  extraSpecialArgs = {
                    # Various assets used in config
                    assets = homeAssets;
                  };
                };
              })
          ] ++ (attrValues self.nixosModules) # Shared modules in nixos/modules
            ++ (attrValues configs); # Individual config in nixos/hosts/<name>

          # Provide profiles and home configurations as additional module inputs
          specialArgs = {
            profiles = self.nixosProfiles // {
              # Overwrite hardware with upstream-combined variant
              hardware = hardwareProfiles;
            };
            # Provide raw module configs for use with home-manager nixos module
            homes = homeVariants;

            # Provide default user name to system configs
            inherit username;
          };
        }
      ) nixos.hosts;

    # All nix files under homes/modules
    homeModules = homes.modules;

    # For each set of modules under homes/configs/<username>
    # And each variant under homes/configs/<username>/<variant>
    homeConfigurations = mapAttrs
      (name: config:
        home-manager.lib.homeManagerConfiguration {

          # External and shared modules in homes/modules combined with user config
          modules = homeModules ++ [ config ];

          # FIXME: Properly "systemize" output
          pkgs = pkgs.x86_64-linux;

          # Provide profiles as additional module inputs
          extraSpecialArgs = {
            # Various assets used in config
            assets = homeAssets;
          };
        }
      ) homeVariants;

    # System and home config build checks
    checks.x86_64-linux = nixosChecks // homeChecks;

    # Import custom packages via overlay
    overlays.default = import ./pkgs;

    # Export all packages from overlay as well as some installers
    packages = recursiveUpdate overlayPackages {
      # FIXME: Properly "systemize" installer
      x86_64-linux.iso = self.nixosConfigurations.installer.config.system.build.isoImage;
    };
  };
}
