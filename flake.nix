{
  description = "Home-Manager and NixOS configurations of Florian Franzen";

  inputs = {
    # Flake helpers
    digga.url = "github:divnix/digga";
    digga.inputs.nixpkgs.follows = "nixpkgs";
    digga.inputs.nixlib.follows = "nixpkgs";
    digga.inputs.latest.follows = "unstable";
    digga.inputs.nixpkgs-unstable.follows = "unstable";
    digga.inputs.home-manager.follows = "home";

    # Host configurations
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.11";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Hardware profiles
    hardware.url = "github:NixOS/nixos-hardware";

    # Home management
    home.url = "github:nix-community/home-manager";
    home.inputs.nixpkgs.follows = "nixpkgs";

    # Latest wayland tools
    wayland.url = "github:nix-community/nixpkgs-wayland";
    wayland.inputs.nixpkgs.follows = "nixpkgs";

    # Firefox Addons
    firefox-addons.url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
    firefox-addons.inputs.nixpkgs.follows = "nixpkgs";

    # Latest emacs and framework
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    emacs-overlay.inputs.nixpkgs.follows = "nixpkgs";

    spacemacs.url = "github:syl20bnr/spacemacs";
    spacemacs.flake = false;
  };

  outputs = {
    self,
    digga,
    nixpkgs,
    unstable,
    hardware,
    home,
    wayland,
    firefox-addons,
    emacs-overlay,
    spacemacs
  } @ inputs: let

    inherit (builtins) attrNames attrValues filter foldl' mapAttrs isAttrs;

    inherit (nixpkgs.lib) filterAttrs mapAttrs' recursiveUpdate;

    # Import helpers to walk git directory tree
    readTree = digga.lib.rakeLeaves;

    flattenTree = digga.lib.flattenTree;

    joinTree = { name ? "imports", recurse ? true }:
      let
        recJoin = _: attrs: { 
          ${name} = (map 
            (v: if isAttrs v 
                then (if recurse then recJoin v else flattenTree v)
                else v)
                (attrValues attrs)
          );
        };
      in
        recJoin;

    # Helpers to parse module folder structure
    readModuleTree = dir: mapAttrs (joinTree {}) (readTree dir);

    # Helpers to parse host folder structure
    readHostTree = dir: mapAttrs 
      (joinTree { name = "modules"; recurse = false; })
      (readTree dir);

    # Create a module with a key set
    mkMod = key: val: {...}: { ${key} = val; };

    # Helpers to parse experimental varients directory strucutre
    readHomeTree = dir: let
      tree = readTree dir;

      # Ignore all files in subfolders for base user config
      mkUser = _: mods:
        mkMod "imports" (filter (e: ! isAttrs e) (attrValues mods));

      users = builtins.mapAttrs mkUser tree;

      # Extend user config with varient and username fix
      mkVarient = user: mods:
        mkMod "imports" (
          (users.${user} {}).imports ++
          (attrValues mods) ++
          [({ lib, ... }: {
            home.username = lib.mkForce user;
            home.homeDirectory = lib.mkForce "/home/${user}";
          })]
        );

      # Extract each subfolder as varient
      toVarients = user: mods:
        mapAttrs' (var: mods: {
          name = "${user}-${var}";
          value = mkVarient user mods;
        }) (filterAttrs (_: v: isAttrs v) mods);

      # Collect varients for all users
      varients = foldl'
        (sum: user: sum // (toVarients user tree.${user}))
        {}
        (attrNames tree);
    in
      users // varients;

    # Turn string list of subdirs into attrset of tree imports
    mkImportables = dirs: nixpkgs.lib.genAttrs dirs (n: readTree (./. + "/${n}"));

    # Shared host and home modules
    modules = readModuleTree ./modules;

    # Import custom packages as overlay
    pkgs-overlay = import ./pkgs;

    # Import unstable overlay 
    # TODO: Currently broken and unused
    unstable-overlay = import ./pkgs/unstable.nix;

    # Import sway gestures overlay
    sway-overlay = import ./pkgs/sway-gestures.nix;

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
    channels = {
      # TODO Check sharedOverlays
      nixpkgs.overlays = [
        emacs-overlay.overlay
        firefox-addons-overlay
        pkgs-overlay
      ];

      unstable.overlays = [
        wayland.overlay
        sway-overlay
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

      hosts = recursiveUpdate (readHostTree ./hosts) {
        satoshi.channelName = "unstable";
      };

      importables = let
        imported = mkImportables [ "hardware" "profiles" "services" ];
      in imported // {
        hardware = hardware.nixosModules // imported.hardware;

        suites = {
          full = with imported.profiles; [ imported.hardware.pipewire media mail office ];
        };
      };
    };

    # home-manager home configs
    home = {
      modules = [ modules.homes ];
      importables = mkImportables [ "themes" ] // {
        inherit self inputs;
      };

      users = readHomeTree ./homes;
    };

    homeConfigurations = digga.lib.mkHomeConfigurations self.nixosConfigurations;

    # system build checks
    checks.x86_64-linux = builtins.mapAttrs
      (_: config: config.config.system.build.toplevel)
      self.nixosConfigurations;
  };
}
