{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
     thunderbird

     element-desktop
     signal-desktop
     mumble

     offlineimap
     mu
  ];
}

