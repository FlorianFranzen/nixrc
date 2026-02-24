{ config, pkgs, username, ... }:

{
  # Useful packages for development
  environment.systemPackages = with pkgs; [
     spice-gtk
  ];

  programs.virt-manager.enable = true;

  # Enable virtualization
  virtualisation.libvirtd.enable = true;

  # Enable USB redirect support
  virtualisation.spiceUSBRedirection.enable = true;

  # Do not filter DHCP
  networking.firewall.checkReversePath = false;

  # Give default users access to libvirtd
  users.extraUsers.${username}.extraGroups = [ "libvirtd" ];
}
