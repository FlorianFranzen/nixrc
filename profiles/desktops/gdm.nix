{
  services.xserver = {
    # TODO: Make this work without X11
    enable = true;

    # Enable GDM display manager
    displayManager.gdm.enable = true;
  };
}
