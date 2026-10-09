{ pkgs, ... }:

{
  # Enable pulseaudio with bluetooth 
  services.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull; # Only full has bluetooth
   };

  # Enable pulseaudio clients
  nixpkgs.config = {
    pulseaudio = true;
  };

  environment.systemPackages = with pkgs; [
    pavucontrol
  ];
}
