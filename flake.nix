{
  description = "Nix and NixOS configurations of Florian Franzen";

  inputs = {
    # Basis for configuration
    nixpkgs.url = "github:nixos/nixpkgs/release-20.09";

    # Useful overlay
    home-manager.url = "github:nix-community/home-manager/release-20.09";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    emacs-overlay.url = "github:nix-community/emacs-overlay";

#    w3fpkgs.url = "git+https://gitlab.w3f.tech/florian/w3fpkgs";
#    w3fpkgs.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, emacs-overlay }: {

    nixosConfigurations = import ./hosts {
      inherit self nixpkgs home-manager emacs-overlay;
    };

    checks.x86_64-linux = nixpkgs.lib.mapAttrs
      (_: config: config.config.system.build.toplevel)
      self.nixosConfigurations;
  };
}
