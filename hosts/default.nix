{ self, nixpkgs, home-manager }:

with nixpkgs.lib;

let
  mkConfig = name: {
    imports = [
      (./. + "/${name}/config.nix")
      (./. + "/${name}/hardware.nix")
    ];

    networking.hostName = name;

    nix.nixPath = [
      "nixpkgs=${nixpkgs}"
    ];

    nix.registry = {
      nixrc.flake = self;
      nixpkgs.flake = nixpkgs;
      home-manager.flake = home-manager;
    };

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
