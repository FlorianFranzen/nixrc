{ pkgs, ... }:

{
  # Enable pulseaudio with bluetooth 
  services.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull; # Only full has bluetooth
   };

  environment.systemPackages = with pkgs; [
    pavucontrol
  ];
}
