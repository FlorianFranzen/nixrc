{
  system = "x86_64-linux";

  modules = [{
    imports = [
      ./config.nix
      ./hardware.nix
    ];
  }];
}
