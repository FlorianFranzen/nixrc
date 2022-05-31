{ config, pkgs, ... }:

{
  nix = {
    # Collect garbage and optimise store once a day
    gc.automatic = true;
    optimise.automatic = true;

    # Allow access to needed external ressources
    extraOptions = ''
      allowed-uris = https://github.com/ git://github.com/ https://static.rust-lang.org/dist/
    '';
  };

  # Enable hydra with local builds
  services.hydra = {
    enable = true;
    hydraURL = "http://localhost:3000";
    notificationSender = "hydra@localhost";
    buildMachinesFiles = [];
    useSubstitutes = true;
    minimumDiskFree = 50;	
  };

  networking.firewall.allowedTCPPorts = [ 3000 ];

  # Useful tools
  environment.systemPackages = [
    pkgs.nix-top
    pkgs.hydra-cli
  ];
}

