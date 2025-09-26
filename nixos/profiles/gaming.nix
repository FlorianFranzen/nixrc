{ config, pkgs, lib, ... }:

{
  # Enable 32bit pipewire alsa, if pipewire alsa is enabled
  services.pipewire.alsa.support32Bit = config.services.pipewire.alsa.enable;

  # Setup gamescope helper
  programs.gamescope = {
    enable = true;

    capSysNice = true;
  };

  # Setup steam environment
  programs.steam = {
    enable = true;

    gamescopeSession.enable = true;
  };

  # Provide microphone noide filtering
  programs.noisetorch.enable = true;

  # Additional games to install
  environment.systemPackages = with pkgs; [
    cemu
    clonehero
    discord
    dolphin-emu
    easyeffects
    goverlay
    joycond
    mangohud
    mindustry
    ryubing
    superTuxKart
    suyu
    (warzone2100.override { withVideos = true; })
    wineWowPackages.wayland
    winetricks
  ];
}
