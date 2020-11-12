{
  description = "Nix and NixOS configurations of Florian Franzen";

  inputs = {
     nixpkgs.url = "github:nixos/nixpkgs/nixos-20.09";
  };

  outputs = { self, nixpkgs }: {

    nixosConfigurations = import ./hosts { pkgs = nixpkgs; };

  };
}
