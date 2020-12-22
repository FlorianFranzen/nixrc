{ ... }:

{
  containers.hydra = {
    config = import ../services/hydra.nix;

    forwardPorts = {
      containerPort = 3000;
      hostPort = 8080;
    };
  };
}
