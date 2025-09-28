{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    mpd
    mpc_cli
    mpdris2
    (ncmpcpp.override { visualizerSupport = true; })

    mpv
    vlc

    ffmpeg
    mkvtoolnix

    spotify
  ];
}
