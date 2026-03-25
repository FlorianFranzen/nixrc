{ ... }:

{
  networking = {
    # Configure static gateway on primary interface
    defaultGateway = {
      address = "10.64.0.254";
      interface = "eno2";
    };

    defaultGateway6 = {
      address = "fd64::fffe";
      interface = "eno2";
    };

    interfaces = {
      # Configure primary ethernet interface
      eno2 = {
        ipv4.addresses = [{
          address = "10.64.0.10";
          prefixLength = 24;
        }];

        ipv6.addresses = [{
          address = "fd64::a";
          prefixLength = 64;
        }];

        wakeOnLan.enable = true;
      };

      # Configure secondary ethernet interface
      eno1 = {
        ipv4.addresses = [{
          address = "10.64.0.11";
          prefixLength = 24;
        }];

        ipv6.addresses = [{
          address = "fd64::b";
          prefixLength = 64;
        }];

        wakeOnLan.enable = true;
      };

      # Enable DHCP on wireless interfaces
      wlan0.useDHCP = true;
    };

    # Configure static nameservers
    nameservers = [ "10.64.0.254" "fd64::fffe" ];
  };
}
