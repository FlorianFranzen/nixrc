{ pkgs, ... }:

{
  systemd.network = {
    # Use systemd networkd
    enable = true;

    networks = {
      # Main 10G interface
      "10-eno2" = {
        matchConfig.Name = "eno2";
        address = [ "10.64.0.10/24" "fd64::a/64" ];
        routes = [
          { Gateway = "10.64.0.254"; Metric = 10; }
          { Gateway = "fd64::fffe"; Metric = 10; }
	];
        dns = [ "10.64.0.254" "fd64::fffe" ];

        # Buggy, so not always connected
        linkConfig.RequiredForOnline = "no";
      };
      # Main 2.5G interface
      "20-eno1" = {
        matchConfig.Name = "eno1";
        address = [ "10.64.0.11/24" "fd64::b/64" ];
        routes = [
          { Gateway = "10.64.0.254"; Metric = 20; }
          { Gateway = "fd64::fffe"; Metric = 20; }
        ];
        dns = [ "10.64.0.254" "fd64::fffe" ];
      };
    };
  };

  networking = {
    # Disable generic receive offload
    localCommands = ''
      ${pkgs.ethtool}/bin/ethtool -K eno2 gro off
    '';

    # Disable default DHCP client
    useDHCP = false;
  };
}
