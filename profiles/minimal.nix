# Base config for all hosts

{ config, pkgs, ... }:

{
  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    binutils
    pciutils
    usbutils
    psmisc
    lshw
    htop
    bind
     
    file
    git 
    p7zip 
    tree
  ];

  # Enable base programs
  programs = {
    tmux = {
      enable = true;
      keyMode = "vi";
      clock24 = true;
    };
  
    zsh = { 
      enable = true;
      enableGlobalCompInit = false; 
    };
  };

  # Enable SSH login via key
  services.openssh.enable = true;
  services.openssh.passwordAuthentication = false;
  security.pam.enableSSHAgentAuth = true;

  # Add default users
  users.extraUsers.florian = {
    isNormalUser = true;
    description = "Florian Franzen";
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
  };
}
