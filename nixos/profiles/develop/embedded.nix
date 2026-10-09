{
  services.udev.extraRules = ''
    # NXP LPC (unbooted LPC18/LPC43 device waiting for DFU)
    SUBSYSTEM=="usb", ATTRS{idVendor}=="1fc9", ATTRS{idProduct}=="000c", MODE="0666"

    # LPC18/43 running the lpcscrypt firmware
    SUBSYSTEM=="tty", ATTRS{idVendor}=="1fc9", ATTRS{idProduct}=="0083", MODE="0666"

    # SEGGER JLink
    ATTR{idVendor}=="1366", ATTR{idProduct}=="0105", MODE="666"
  '';
}
