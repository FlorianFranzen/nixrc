{
  services.udev.extraRules = ''
    # Block rubber ducky
    SUBSYSTEM=="usb", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="2401", ATTR{authorized}="0"
  '';
}
