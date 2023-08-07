{ pkgs, lib, ... }:

{
  hardware = {
    opengl = {
      enable = true;

      driSupport = true;

      extraPackages = with pkgs; [
        vaapiIntel
        vaapiVdpau
        libvdpau-va-gl
      ];

      driSupport32Bit = true;

      extraPackages32 = with pkgs.pkgsi686Linux; [
        vaapiIntel
        libvdpau-va-gl
        vaapiVdpau
      ];
    };

    steam-hardware.enable = true;
  };

  services.pipewire.alsa.support32Bit = true;

  environment.systemPackages = with pkgs; [
    _20kly
    minecraft
    #openclonk
    openjk
    openra
    steam
    steam-run
    superTuxKart
    (warzone2100.override { withVideos = true; })
    wineWowPackages.wayland
    winetricks
  ];
}
