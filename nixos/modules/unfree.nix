{ config, pkgs, lib, ... }:

{
  # Ignore common unfree license warning
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    # Unfree nvidia driver
    "nvidia-x11" "nvidia-persistenced" "nvidia-settings" 
    # Unfree MacBook wireless
    "broadcom-sta"
    # Unfree wooting utility
    "wootility"
    # Nitrokey firmware updates
    "nrfutil" "pc-ble-driver-py" "pc-ble-driver" "pypemicro"
    # Steam and other gaming
    "steam" "steam-original" "steam-run" "minecraft-launcher" "clonehero" "discord"
    # Printer and scanner drivers
    "cups-brother-mfcl2710dw" "brscan4" "brother-udev-rule-type1" "brscan4-etc-files"
    # Dictionaries
    "aspell-dict-en-science"
    # Some corpoware
    "slack" "zoom"
  ];
}
