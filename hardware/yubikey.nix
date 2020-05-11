{ config, pkgs, ... }:

{
 # ToDo: Config expects desktop environment 

 # Install command line utility
  environment.systemPackages = with pkgs; [
    yubikey-personalization
    (pass-wayland.withExtensions (exts: [
      exts.pass-audit 
      exts.pass-genphrase 
      exts.pass-otp
      exts.pass-update
    ]))
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
      pinentryFlavor = "qt";
    };

    # Enable browserpass native handler
    browserpass.enable = true;
  };

  # Give user access to yubikey hardware
  services.udev.packages = with pkgs; [
    yubikey-personalization
  ];

  # Enable SmartCard support
  services.pcscd.enable = true;
}
