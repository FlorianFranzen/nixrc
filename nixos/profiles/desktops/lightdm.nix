{
  # Add trackpad support
  services.libinput = {
    enable = true;
    touchpad.tapping = false;
  };

  services.xserver = {
    # Currently runs on X11
    enable = true;

    # Enable lightdm itself
    displayManager.lightdm.enable = true;
  };
}
