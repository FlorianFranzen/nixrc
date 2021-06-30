{ config, pkgs, ... }:

{

  nixpkgs.config = {
    #allowUnfree = true;
   
    kodi = { 
      #enableAdvancedLauncher = true;      
      #enableAdvancedEmulatorLauncher = true;
      #enableControllers = true;      
      #enableExodus = true;
      #enableHyperLauncher = true;
      #enableJoystick = true;
      #enableOSMCskin = true;
      #enableSteamLauncher = true;
    };
  };

  # Enable kodi media server
  services.xserver = {
    enable = true;

    libinput.enable = true;

    desktopManager.kodi.enable = true;
  };

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  users.users.kodi = {
    isSystemUser = true;
    home = "/data/kodi";
  };
}
