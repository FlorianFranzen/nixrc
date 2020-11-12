{
  system = "x86_64-linux";

  modules = [{
    imports = [
      ./config.nix
      ./hardware.nix
      # Select usage profile
      ./../../profiles/full.nix
      ./../../profiles/virtual.nix
      ./../../profiles/docker.nix
      ./../../profiles/gaming.nix
      # Select developer profile
      ./../../develop/default.nix
      ./../../develop/extra.nix
      # Select desktop stack
      ./../../desktops/sway.nix
      ./../../desktops/i3.nix
      # Select network stack
      #./../../networks/networkmanager.nix
      ./../../networks/iwd.nix
      #./../../networks/wpasupplicant.nix
      # Select service to run
      ./../../services/btrbk.nix
      # Additional hardware support
      ./../../hardware/yubikey.nix
    ];
  }];
}
