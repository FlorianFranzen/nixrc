{ config, pkgs, ... }:

{  
  # Useful packages for development
  environment.systemPackages = with pkgs; [
     virtmanager
     spice-gtk
  ];
 
  # Enable virtualization
  virtualisation.libvirtd.enable = true;

  # Do not filter DHCP
  networking.firewall.checkReversePath = false;

  # Allow sbit for spice usb acl helper
  security.wrappers.spice-client-glib-usb-acl-helper.source =
    "${pkgs.spice-gtk}/bin/spice-client-glib-usb-acl-helper";

  # Security settings 
  security.polkit = {
    enable = true;
    extraConfig = ''
      polkit.addRule(function(action, subject) { 
        if (action.id == "org.spice-space.lowlevelusbaccess" &&
            subject.isInGroup("libvirtd")) {
          return "yes";
        }
      });
    '';
  };

  # Give default users access to libvirtd
  users.extraUsers.florian = {
    extraGroups = [ "libvirtd" ]; 
  };
}
