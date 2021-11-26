{
  description = "Home-Manager and NixOS configurations of Florian Franzen";

  inputs = {
    # Flake helpers
    digga.url = "github:divnix/digga";
    digga.inputs.nixpkgs.follows = "nixpkgs";
    digga.inputs.nixlib.follows = "nixpkgs";
    digga.inputs.latest.follows = "nixpkgs";
    digga.inputs.home-manager.follows = "home";

    # Host configurations
    nixpkgs.url = "github:FlorianFranzen/nixpkgs/nixos-unstable";

    # Hardware profiles
    hardware.url = "github:NixOS/nixos-hardware";

    # Home management
    home.url = "github:nix-community/home-manager";
    home.inputs.nixpkgs.follows = "nixpkgs";

    # Firefox Addons
    firefox-addons.url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
    firefox-addons.inputs.nixpkgs.follows = "nixpkgs";

    # Latest emacs and framework
    emacs-overlay.url = "github:nix-community/emacs-overlay";

    spacemacs.url = "github:syl20bnr/spacemacs";
    spacemacs.flake = false;
  };

  outputs = {
    self,
    digga,
    nixpkgs,
    hardware,
    home,
    firefox-addons,
    emacs-overlay,
    spacemacs
  } @ inputs: let

    # Recursive import helpers
    importTree = digga.lib.rakeLeaves;

    importFlatTree = name: dir: builtins.mapAttrs
      (_: mods: {...}: { ${name} = builtins.attrValues mods; })
      (importTree dir);

    importModuleTree = dir: builtins.mapAttrs
      (_: mods: {...}: { imports = builtins.attrValues mods; })
      (importTree dir);

    # Turn string list of subdirs into attrset of tree imports
    mkImportables = dirs: nixpkgs.lib.genAttrs dirs (n: importTree (./. + "/${n}"));

    # Shared host and home modules 
    modules = importModuleTree ./modules;

    # Import custom packages as overlay
    pkgs-overlay = import ./pkgs;

    # Turn firefox addon collection to overlay
    firefox-addons-overlay = (self: super: {
      buildFirefoxXpiAddon = firefox-addons.lib.${super.system}.buildFirefoxXpiAddon;
      firefox-addons = firefox-addons.packages.${super.system};      
    });  

  in digga.lib.mkFlake {

    inherit self inputs;

    # exclude darwin or 32bit linux
    supportedSystems = ["aarch64-linux" "x86_64-linux"];

    # nixpkgs versions and configs
    channels.nixpkgs = {
      # TODO Check sharedOverlays
      overlays = [ 
        emacs-overlay.overlay 
        firefox-addons-overlay
        pkgs-overlay
      ];
    };

    # nixos system configs
    nixos = {
      hostDefaults = {
        system = "x86_64-linux";

        channelName = "nixpkgs";

        modules = [
          modules.hosts
          #digga.nixosModules.bootstrapIso
          #digga.nixosModules.nixConfig
          home.nixosModules.home-manager
        ];
      };

      hosts = importFlatTree "modules" ./hosts;

      importables = let
        imported = mkImportables [ "hardware" "profiles" "services" ];
      in imported // {
        hardware = hardware.nixosModules // imported.hardware;

        suites = {
          full = with imported.profiles; [ media mail office ];
        };
      };
    };

    # home-manager home configs
    home = {
      modules = [ modules.homes ];
      importables = mkImportables [ "themes" ] // { 
        inherit self inputs; 
      };
      users = importModuleTree ./homes;
    };

    # system build checks
    checks.x86_64-linux = builtins.mapAttrs
      (_: config: config.config.system.build.toplevel)
      self.nixosConfigurations;
  };
}
