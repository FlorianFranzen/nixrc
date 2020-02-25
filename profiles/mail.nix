{ config, pkgs, ... }:

{  
  environment.systemPackages = with pkgs; [
     thunderbird
     
     offlineimap
     mu
  ];
}

