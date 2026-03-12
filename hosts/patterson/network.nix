{ ... }:

{
  # Configure main ethernet interface
  networking.interfaces.end0 = {
    # - default static ip address
    ipv4.addresses = [{
      address = "10.64.2.5";
      prefixLength = 24;
    }];
  
    # - enable DHCP as well
    useDHCP = true;
  };
}

