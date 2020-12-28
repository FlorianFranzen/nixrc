{ ... }:

{
  containers.hydra = {
    config = import ../services/hydra.nix;
  };

  networking.firewall.allowedTCPPorts = [ 3000 ];
}
