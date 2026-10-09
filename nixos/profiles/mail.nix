{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
     thunderbird

     element-desktop
     signal-desktop
     telegram-desktop
     mumble

     offlineimap
     mu
  ];
}

