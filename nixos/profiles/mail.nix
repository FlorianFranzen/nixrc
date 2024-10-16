{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
     thunderbird

     element-desktop
     signal-desktop
     tdesktop
     mumble

     offlineimap
     mu
  ];
}

