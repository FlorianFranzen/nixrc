{ config, pkgs, lib, ... }:

{
  # Enable 32bit pipewire alsa, if pipewire alsa is enabled
  services.pipewire.alsa.support32Bit = config.services.pipewire.alsa.enable;

  # Setup steam environment
  programs.steam.enable = true;

  # Provide microphone noide filtering
  programs.noisetorch.enable = true;

  # Additional games to install
  environment.systemPackages = with pkgs; [
    _20kly
    cemu
    discord
    goverlay
    mangohud
    minecraft
    mindustry
    openra
    superTuxKart
    (warzone2100.override { withVideos = true; })
    wineWowPackages.wayland
    winetricks
    yuzu
  ];
}
