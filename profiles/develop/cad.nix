{ pkgs, ... }:

{
  # Useful packages for "hardware" developement
  environment.systemPackages = with pkgs; [
     openscad-unstable
     librecad
     freecad
     kicad
  ];
}
