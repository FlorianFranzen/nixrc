{ ... }:

{
  networking.interfaces= {
    # Enable DHCP and WakeOnLAN on wired interfaces
    eno1.useDHCP = true;
    eno1.wakeOnLan.enable = true;

    eno2.useDHCP = true;
    eno2.wakeOnLan.enable = true;

    # Enable DHCP on wireless interfaces (hangs boot)
    #wlp7s0.useDHCP = true;
  };
}
