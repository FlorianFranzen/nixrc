{ config, pkgs, ... }:

{
  # Enable sound.
  sound.enable = true;

  # Enable pulseaudio with bluetooth 
  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull; # Only full has bluetooth
  };
    
  nixpkgs.config = {
    pulseaudio = true;
  };

  environment.systemPackages = with pkgs; [
    pavucontrol
    paprefs

    mpd	
    mpc_cli
    ncmpcpp
#     (ncmpcpp.override { visualizerSupport = true; })
#     gmpc
#     quodlibet

    mpv
    vlc
 
    ffmpeg
    mkvtoolnix
  ]; 
}
