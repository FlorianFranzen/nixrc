{ config, pkgs, ... }:

{  
  # Useful packages for "hardware" developement
  environment.systemPackages = with pkgs; [
     openscad
     librecad
     freecad
     kicad 
  ];
}
