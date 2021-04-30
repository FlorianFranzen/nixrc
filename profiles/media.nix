{ config, pkgs, ... }:

{
  # Enable pipewire
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  # Enable pulseaudio clients
  nixpkgs.config = {
    pulseaudio = true;
  };

  environment.systemPackages = with pkgs; [
    pulseaudio # for pactl
    pavucontrol

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
