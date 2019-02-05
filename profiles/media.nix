{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
     mpd
     mpc_cli
     ncmpcpp
#     gmpc
#     quodlibet
     vlc
 
     ffmpeg
     mkvtoolnix
   ]; 
}
