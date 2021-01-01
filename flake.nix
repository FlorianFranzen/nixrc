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

    nixosConfigurations = import ./hosts { inherit self nixpkgs; };

    checks.x86_64-linux = nixpkgs.lib.mapAttrs
      (_: config: config.config.system.build.toplevel)
      self.nixosConfigurations;
  };
}
