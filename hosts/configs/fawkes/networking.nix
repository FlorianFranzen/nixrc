{ ... }:

{
  networking.interfaces= {
    # Enable DHCP on all interfaces
    eno1.useDHCP = true;
    eno2.useDHCP = true;
    wlp7s0.useDHCP = true;
  };
}
