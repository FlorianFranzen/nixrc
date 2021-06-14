{
  description = "Nix and NixOS configurations of Florian Franzen";

  inputs = {
    # Basis for configuration
    nixpkgs.url = "github:nixos/nixpkgs/nixos-21.05";

    # Useful overlay
    home-manager.url = "github:nix-community/home-manager/release-21.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    emacs-overlay.url = "github:nix-community/emacs-overlay";
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
