{
  description = "Nix and NixOS configurations of Florian Franzen";

  inputs = {
    # Basis for configuration
    nixpkgs.url = "github:nixos/nixpkgs/nixos-20.09";

    # Useful overlay
#    w3fpkgs.url = "git+https://gitlab.w3f.tech/florian/w3fpkgs";
#    w3fpkgs.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs }: {

    nixosConfigurations = import ./hosts { pkgs = nixpkgs; };

    checks.x86_64-linux = {
      chomsky = self.nixosConfigurations.chomsky.config.system.build.toplevel;
      hull = self.nixosConfigurations.hull.config.system.build.toplevel;
      tesla = self.nixosConfigurations.tesla.config.system.build.toplevel;
      pavlov = self.nixosConfigurations.pavlov.config.system.build.toplevel;
    };
  };
}
