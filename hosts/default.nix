{ self, nixpkgs }:

with nixpkgs.lib;

let
  mkHost = system: name: nixosSystem {
    inherit system;

    modules = [
      {
        imports = [
          (./. + "/${name}/config.nix")
          (./. + "/${name}/hardware.nix")
        ];

        networking.hostName = name;

        nix.nixPath = [
          "nixpkgs=${nixpkgs}"
        ];

        #nixpkgs.pkgs = nixpkgs;

        nix.registry = {
          nixrc.flake = self;
          nixpkgs.flake = nixpkgs;
        };

        system.configurationRevision = mkIf (self ? rev) self.rev;
      }
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
