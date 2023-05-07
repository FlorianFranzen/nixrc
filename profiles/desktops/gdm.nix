{ lib, ... }:

{
  services.xserver = {
    # TODO: Make this work without X11
    enable = true;

    # Enable GDM display manager
    displayManager.gdm.enable = true;
  };

  # Do not enable ask password with xserver
  programs.ssh.enableAskPassword = lib.mkDefault false;
}
