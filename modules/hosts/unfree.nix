{ config, pkgs, lib, hardware, ... }:

{
  # Ignore common unfree license warning
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    # Unfree nvidia driver
    "nvidia-x11" "nvidia-persistenced" "nvidia-settings" 
    # Unfree MacBook wireless
    "broadcom-sta"
    # Nitrokey firmware updates
    "nrfutil" "pc-ble-driver-py" "pc-ble-driver" "pypemicro"
    # Steam Gaming
    "steam" "steam-run"
  ];
}