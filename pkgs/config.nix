# Shared nixpkgs configuration (unfree allow-list, licenses, insecure
# exceptions). Used by every NixOS host via modules/unfree.nix and by the
# flake's own package sets, which build the overlay packages and ftl layers.
{ lib }:

{
  # Ignore common unfree license warning
  allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      # Unfree nvidia driver
      "nvidia-kernel-modules"
      "nvidia-persistenced"
      "nvidia-settings"
      "nvidia-x11"
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
      "discord-unwrapped"
      # Media apps
      "spotify"
      # Firefox addons
      "video-downloadhelper"
      "youtube-recommended-videos"
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

  input-fonts.acceptLicense = true;

  # Needed by some barely maintained software
  permittedInsecurePackages = [
    "jitsi-meet-1.0.8792"
    "qtwebengine-5.15.19"
  ];
}
