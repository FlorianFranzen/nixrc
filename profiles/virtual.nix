{ config, pkgs, username, ... }:

{
  # Useful packages for development
  environment.systemPackages = with pkgs; [
    spice-gtk
  ];

  programs.virt-manager.enable = true;

  virtualisation.libvirtd = {
    # Enable virtualization via libvirtd
    enable = true;

    # Enable virtiofs support via daemon
    qemu.vhostUserPackages = with pkgs; [ virtiofsd ];
  };

  # Enable USB redirect support
  virtualisation.spiceUSBRedirection.enable = true;

  # Do not filter DHCP
  networking.firewall.checkReversePath = false;

  # Give default users access to libvirtd
  users.extraUsers.${username}.extraGroups = [ "libvirtd" ];
}
