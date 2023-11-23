{
  description = "Home-Manager and NixOS configurations of Florian Franzen";

  inputs = {
    # Nix Import helper
    haumea.url = "github:nix-community/haumea/v0.2.2";
    haumea.inputs.nixpkgs.follows = "nixpkgs";

    # Base packages and configurations
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Hardware profiles
    hardware.url = "github:NixOS/nixos-hardware";

    # Secure boot support
    lanzaboote.url = "github:FlorianFranzen/lanzaboote/v0.3.0-mirror";
    lanzaboote.inputs.nixpkgs.follows = "nixpkgs";

    # Home management 
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Firefox Addons
    firefox-addons.url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
    firefox-addons.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    haumea,
    nixpkgs,
    hardware,
    lanzaboote,
    home-manager,
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

    # Import all host profiles, modules and configs as paths
    hosts = haumea.lib.load {
      src = ./hosts;
      loader = haumea.lib.loaders.path;
    };

    # Import all home profiles, modules and configs as paths
    homes = haumea.lib.load {
      src = ./homes;
      loader = haumea.lib.loaders.path;
    };

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
      desktop-modules = attrValues homes.desktop;

      desktops = mapAttrs' (name: config: {
          name = "desktop-${name}";
          value = mkModule (terminal-modules ++ desktop-modules ++ [ config ]); 
        }) homes.variants;

    in (terminals // desktops);

    # Various assets used in home config
    homeAssets = {
      # Some wallpapers to be used in theming
      wallpaper-astronaut-gruvbox = ./homes/assets/astronaut-gruvbox.jpg;
      wallpaper-nixish-dark = ./homes/assets/nixish-dark.png;
      wallpaper-snowflake-solarized = ./homes/assets/snowflake-solarized.png;
      wallpaper-mojave-dark = ./homes/assets/mojave-dark.jpg;
    };

    # Output each system toplevel build as a check
    hostChecks = mapAttrs' (name: config: {
      name = "host-${name}";
      value = config.config.system.build.toplevel;
    }) self.nixosConfigurations;

    # Output each home activation package as a check
    homeChecks = mapAttrs' (name: config: {
      name = "home-${name}";
      value = config.activationPackage;
    }) self.homeConfigurations;

  in {
    # All nix files under hosts/modules
    nixosModules = hosts.modules;

    # All nix files under hosts/profiles
    nixosProfiles = hosts.profiles;

    # For each set of modules under hosts/configs/<hostname>
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
                  useGlobalPkgs = true;
                  useUserPackages = true;

                  # Shared modules in homes/modules
                  sharedModules = attrValues self.homeModules;

                  # Provide profiles as additional module inputs
                  extraSpecialArgs = {
                    # Profiles in homes/profiles
                    profiles = self.homeProfiles;

                    # Various assets used in config
                    assets = homeAssets;
                  };
                };
              })
          ] ++ (attrValues self.nixosModules) # Shared modules in hosts/modules
            ++ (attrValues configs); # Individual config in hosts/configs/<name>

          # Provide profiles and home configurations as additional module inputs
          specialArgs = {
            profiles = self.nixosProfiles // {
              # Inject and overlay nixos-hardware in/with profiles
              hardware = hardware.nixosModules // self.nixosProfiles.hardware;
            };
            # Provide raw module configs for use with home-manager nixos module
            homes = homeVariants;

            # Provide default user name to system configs
            inherit username;
          };
        }
      ) hosts.configs;

    # All nix files under homes/modules
    homeModules = homes.modules;

    # All nix files under homes/modules
    homeProfiles = homes.profiles;

    # For each set of modules under homes/configs/<username>
    # And each variant under homes/configs/<username>/<variant>
    homeConfigurations = mapAttrs
      (name: config:
        home-manager.lib.homeManagerConfiguration {

          # Shared modules in homes/modules and user modules in homes/configs/<name>
          # Optionally extended by variant modules in homes/configs/<name>/<variant>
          modules = (attrValues self.homeModules) ++ [ config ];

          # FIXME: Properly "systemize" output
          pkgs = pkgs.x86_64-linux;

          # Provide profiles as additional module inputs
          extraSpecialArgs = {
            # Profiles in homes/profiles
            profiles = self.homeProfiles;

            # Various assets used in config
            assets = homeAssets;
          };
        }
      ) homeVariants;

    # System and home config build checks
    checks.x86_64-linux = hostChecks // homeChecks;

    # Import custom packages via overlay
    overlays.default = import ./pkgs;

    # Export all packages from overlay as well as some installers
    packages = recursiveUpdate overlayPackages {
      # FIXME: Properly "systemize" installer
      x86_64-linux.iso = self.nixosConfigurations.installer.config.system.build.isoImage;
    };
  };
}
