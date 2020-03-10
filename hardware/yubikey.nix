{ config, pkgs, ... }:

{
 # ToDo: Config expects desktop environment 

 # Install command line utility
  environment.systemPackages = with pkgs; [
    yubikey-personalization
    pass
    #pass-wayland
    pwgen
  ];
 
  # Allow the use of u2f devices
  hardware.u2f.enable = true;

  # Enable GnuPG with ssh support
  programs = {
    ssh.startAgent = false;

    gnupg.agent = { 
      enable = true; 
      enableSSHSupport = true; 
      enableExtraSocket = true;
    };

    # Enable browserpass native handler
    browserpass.enable = true;
  };
 
  nixpkgs.config.packageOverrides = pre: {
    # Disabled to not build Libreoffice from source
    #gnupg = pre.gnupg.override {
    #  pinentry = pre.pinentry_qt5;
    #};
  };

  # Give user access to yubikey hardware
  services.udev.packages = with pkgs; [
    yubikey-personalization
  ];

  # Enable SmartCard support
  services.pcscd.enable = true;
}
