{ ... }:

{
  networking = {
    # Configure default gateway
    defaultGateway = {
      address = "10.64.2.254";
      interface = "enp3s0";
    };

    # Configure main ethernet interface
    interfaces.enp3s0 = {
      ipv4.addresses = [{
        address = "10.64.2.10";
        prefixLength = 24;
      }];

      wakeOnLan.enable = true;
    };

    # Configure default nameserver
    nameservers = [ "10.64.2.254" ];

    # Disable default DHCP
    useDHCP = false;
  };

}

