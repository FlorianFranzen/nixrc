{
  config,
  pkgs,
  lib,
  ...
}:

{
  # Ignore common unfree license warning
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      # Unfree nvidia driver
      "nvidia-x11"
      "nvidia-persistenced"
      "nvidia-settings"
      # Unfree wooting utility
      "wootility"
      # Nitrokey firmware updates
      "nrfutil"
      "pc-ble-driver-py"
      "pc-ble-driver"
      "pypemicro"
      # Steam and other gaming
      "steam"
      "steam-unwrapped"
      "steam-original"
      "steam-run"
      "minecraft-launcher"
      "clonehero"
      "discord"
      # Media apps
      "spotify"
      # Printer and scanner drivers
      "cups-brother-mfcl2710dw"
      "brscan4"
      "brother-udev-rule-type1"
      "brscan4-etc-files"
      # Dictionaries
      "aspell-dict-en-science"
      # Fonts
      "input-fonts"
      # Some corpoware
      "hubstaff"
      "slack"
    ];

  nixpkgs.config.input-fonts.acceptLicense = true;

  # Needed by some barely maintained software
  nixpkgs.config.permittedInsecurePackages = [
    "jitsi-meet-1.0.8792"
    "qtwebengine-5.15.19"
  ];
}
