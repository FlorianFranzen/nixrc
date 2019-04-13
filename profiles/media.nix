{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
     mpd
     mpc_cli
     (ncmpcpp.override { visualizerSupport = true; })
#     gmpc
#     quodlibet
     vlc
 
     ffmpeg
     mkvtoolnix
   ]; 
}
