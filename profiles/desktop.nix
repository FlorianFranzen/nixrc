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
    shared_mime_info
   
    networkmanagerapplet 
    pavucontrol
     
    pywal
#    nerdfonts 
    glib
    gnome3.defaultIconTheme
    numix-gtk-theme
    numix-solarized-gtk-theme
    numix-icon-theme
    elementary-xfce-icon-theme
    numix-cursor-theme
    lxappearance-gtk3

    xfce.xfconf
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

  # Enable gvfs 
  services.gvfs.enable = true;
  environment.variables.GIO_EXTRA_MODULES = [ "${pkgs.gnome3.gvfs}/lib/gio/modules" ];

  users.extraUsers.florian = {
    extraGroups = [ "audio" "video" "networkmanager" ];
  };
}
