{
  # Allow access to userspace syncthing instance
  networking.firewall = { 
    allowedTCPPorts = [ 22000 ];
    allowedUDPPorts = [ 21027 22000 ];
  };
}
