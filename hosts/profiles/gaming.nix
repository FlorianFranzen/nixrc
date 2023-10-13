{ config, pkgs, lib, ... }:

{
  # Additional video accelaration
  hardware = {
    opengl = {
      extraPackages = with pkgs; [
        vaapiVdpau
        libvdpau-va-gl
      ];

      extraPackages32 = with pkgs.pkgsi686Linux; [
        vaapiVdpau
        libvdpau-va-gl
      ];
    };
  };

  # Enable 32bit pipewire alsa, if pipewire alsa is enabled
  services.pipewire.alsa.support32Bit = config.services.pipewire.alsa.enable;

  # Setup steam environment
  programs.steam.enable = true;

  # Additional games to install
  environment.systemPackages = with pkgs; [
    _20kly
    discord
    minecraft
    mindustry
    openjk
    openra
    superTuxKart
    (warzone2100.override { withVideos = true; })
    wineWowPackages.wayland
    winetricks
    yuzu
  ];
}
