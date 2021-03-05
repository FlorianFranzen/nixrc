{ self, nixpkgs, home-manager, emacs-overlay }:

with nixpkgs.lib;

let
  mkConfig = name: {
    imports = [
      (./. + "/${name}/config.nix")
      (./. + "/${name}/hardware.nix")
    ];

    networking.hostName = name;
    networking.hostId = substring 0 8 (builtins.hashString "md5" name);

    nix.nixPath = [
      "nixpkgs=${nixpkgs}"
    ];

    nix.registry = {
      nixrc.flake = self;
      nixpkgs.flake = nixpkgs;
      home-manager.flake = home-manager;
    };

    nixpkgs.overlays = [
      emacs-overlay.overlay
    ];

    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;

    system.configurationRevision = mkIf (self ? rev) self.rev;
  };

  mkHost = system: name: nixosSystem {
    inherit system;

    modules = [
      home-manager.nixosModules.home-manager
      (mkConfig name)
    ];
  };

  systems = {
    x86_64-linux = [
      # Personal Laptop
      "chomsky"

      # Personal Netbook
      "hull"

      # Personal NAS
      "tesla"

      # Personal Workstation
      "pavlov"

      # Personal Cloud
      #"turing"
    ];
  };

  configs = mapAttrs (system: hosts: genAttrs hosts (mkHost system)) systems;

in configs.x86_64-linux
