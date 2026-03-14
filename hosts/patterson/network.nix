{ ... }:

{
  networking = {
    # Configure default gateway
    defaultGateway = {
      address = "10.64.2.254";
      interface = "end0";
    };

    # Configure main ethernet interface
    interfaces.end0 = {
      ipv4.addresses = [{
        address = "10.64.2.5";
        prefixLength = 24;
      }];
    };

    # Configure default nameserver
    nameservers = [ "10.64.2.254" ];

    # Disable default DHCP
    useDHCP = false;
  };
}

