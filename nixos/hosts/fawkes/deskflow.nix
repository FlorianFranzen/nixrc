{ pkgs, ... }:

{
  # Allow access to userspace deskflow instance
  networking.firewall.allowedTCPPorts = [ 24800 ];

  environment.systemPackages = [ pkgs.deskflow ];
}
