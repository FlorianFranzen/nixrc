# Base config to run a desktop environment

{ config, pkgs, ... }:

{
  # Enable sound.
  sound.enable = true;

  # Enable pulseaudio with bluetooth 
  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull; # Only full has bluetooth
    support32Bit = true;
  };
    
  nixpkgs.config = {
    pulseaudio = true;
  };

  # Use network manager
  networking.networkmanager = {
    enable = true;
    dns = "dnsmasq";
  };
  
  # Enable bluetooth
  hardware.bluetooth.enable = true;

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
     networkmanagerapplet 
     pavucontrol
     
     pywal
#     nerdfonts
     numix-cursor-theme
     numix-icon-theme
     numix-gtk-theme
     numix-solarized-gtk-theme
     lxappearance-gtk3

     xfce.mousepad
     xfce.thunar
     xfce.thunar-volman
     xfce.thunar-archive-plugin
     xfce.ristretto
     xfce.tumbler
     xarchiver 
     
     libnotify
     nextcloud-client 
  ];

  # Enable backlight control
  programs.light.enable = true;

  # Enable network manager tray
  programs.nm-applet.enable = true;
  
  # Enable CUPS to print documents.
  #services.printing.enable  = true;
  #services.printing.drivers = [ pkgs.gutenprint ];

  # Enable AVAHI
  #services.avahi.enable = true;

  # Enable dconf  
  programs.dconf.enable = true;
  services.dbus.packages = [ pkgs.gnome3.dconf ];
 
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
    extraGroups = [ "networkmanager" ];
  };
}
