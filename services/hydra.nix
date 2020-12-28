{ config, pkgs, ... }:

{
  nix.extraOptions = ''
    allowed-uris = https://github.com/ https://static.rust-lang.org/dist/
  '';

  services.hydra = {
    enable = true;
    hydraURL = "http://localhost:3000";
    notificationSender = "hydra@localhost";
    buildMachinesFiles = [];
    useSubstitutes = true;
  };
  
  networking.firewall.allowedTCPPorts = [ 3000 ];

  environment.systemPackages = [
    pkgs.nix-top
    pkgs.hydra-cli
  ];
}

