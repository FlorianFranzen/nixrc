{ config, pkgs, ... }:

{  
  # Useful packages for development
  environment.systemPackages = with pkgs; [
     virtmanager
     spice-gtk
  ];
 
  # Enable keybase
  services.keybase.enable = true;

  # Container and virtualization
  virtualisation.docker.enable = true;
  virtualisation.libvirtd.enable = true;

  security.wrappers.spice-client-glib-usb-acl-helper.source =
    "${pkgs.spice-gtk}/bin/spice-client-glib-usb-acl-helper";

  # Security settings 
  security.polkit = {
    enable = true;
    extraConfig = ''
      polkit.addRule(function(action, subject) {
        polkit.log("user " + subject.user + " is attempting action " + action.id + " from PID " + subject.pid);
      }); 

      polkit.addRule(function(action, subject) { 
        if (action.id == "org.spice-space.lowlevelusbaccess" &&
            subject.isInGroup("libvirtd")) {
          return "yes";
        }
      });
    '';
  };

  users.extraUsers.florian = {
    extraGroups = [ "docker" "libvirtd" ]; 
  };
}
