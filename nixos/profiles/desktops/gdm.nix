{ lib, ... }:

{
  # Enable GDM display manager
  services.displayManager.gdm = {
    enable = true;
    autoSuspend = false;
  };
}
