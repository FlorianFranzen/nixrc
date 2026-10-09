{ ... }:

{
  networking = {
    # Configure default gateway
    defaultGateway = {
      address = "10.64.2.254";
      interface = "end0";
    };

    defaultGateway6 = {
      address = "fd64:0:0:2::fffe";
      interface = "end0";
    };

    # Configure main ethernet interface
    interfaces.end0 = {
      ipv4.addresses = [{
        address = "10.64.2.5";
        prefixLength = 24;
      }];

      ipv6.addresses = [{
        address = "fd64:0:0:2::5";
        prefixLength = 64;
      }];
    };

    # Configure default nameserver
    nameservers = [ "10.64.2.254" "fd64:0:0:2::fffe" ];

    # Disable default DHCP
    useDHCP = false;
  };
}
