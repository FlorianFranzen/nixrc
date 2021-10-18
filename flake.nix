{
  description = "Home-Manager and NixOS configurations of Florian Franzen";

  inputs = {
    # Flake helpers
    digga.url = "github:divnix/digga";
    digga.inputs.nixpkgs.follows = "nixos";
    digga.inputs.nixlib.follows = "nixos";
    digga.inputs.latest.follows = "latest";
    digga.inputs.home-manager.follows = "home";

    bud.url = "github:divnix/bud";
    bud.inputs.nixpkgs.follows = "nixos";
    bud.inputs.devshell.follows = "digga/devshell";

    # Host configurations
    nixos.url = "github:nixos/nixpkgs/nixos-21.05";

    # Latest package set
    latest.url = "github:nixos/nixpkgs/nixos-unstable";

    # Hardware profiles
    hardware.url = "github:NixOS/nixos-hardware";

    # Home management
    home.url = "github:nix-community/home-manager/release-21.05";
    home.inputs.nixpkgs.follows = "nixos";

    # Firefox Addons
    firefox-addons.url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";

    # Latest emacs and framework
    emacs-overlay.url = "github:nix-community/emacs-overlay";

    spacemacs.url = "github:syl20bnr/spacemacs";
    spacemacs.flake = false;
  };

  outputs = {
    self,
    digga,
    bud,
    nixos,
    latest,
    hardware,
    home,
    firefox-addons,
    emacs-overlay,
    spacemacs
  } @ inputs: let

    # Recursive import helpers
    importTree = digga.lib.rakeLeaves;

    importTreeByName = name: importTree (./. + "/${name}");

    importFlatTree = name: dir: builtins.mapAttrs
      (_: mods: {...}: { ${name} = builtins.attrValues mods; })
      (importTree dir);

    importModuleTree = dir: builtins.mapAttrs
      (_: mods: {...}: { imports = builtins.attrValues mods; })
      (importTree dir);

    # Shared modules across configs
    common = importTree ./common;

  in digga.lib.mkFlake {

    inherit self inputs;

    # exclude darwin or 32bit linux
    supportedSystems = ["aarch64-linux" "x86_64-linux"];

    # nixpkgs versions and configs
    channels.nixos = {
      # TODO Check sharedOverlays
      overlays = [ 
        emacs-overlay.overlay 
        ./pkgs 
        (self: super: {
          firefox-addons = firefox-addons.packages.${super.system};
        })  
      ];
    };

    # nixos system configs
    nixos = {
      hostDefaults = {
        system = "x86_64-linux";

        channelName = "nixos";

        modules = [
          common.hosts
          #digga.nixosModules.bootstrapIso
          #digga.nixosModules.nixConfig
          home.nixosModules.home-manager
          bud.nixosModules.bud
        ];
      };

      hosts = importFlatTree "modules" ./hosts;

      importables = let
        dirs = [ "hardware" "profiles" "services" ];

        imported = nixos.lib.genAttrs dirs importTreeByName;
      in imported // {
        hardware = hardware.nixosModules // imported.hardware;

        suites = {
          full = with imported.profiles; [ media mail office ];
        };
      };
    };

    # home-manager home configs
    home = {
      modules = [ common.homes ];
      importables = { inherit self inputs; };
      users = importModuleTree ./homes;
    };

    # system build checks
    checks.x86_64-linux = builtins.mapAttrs
      (_: config: config.config.system.build.toplevel)
      self.nixosConfigurations;
  };
}
