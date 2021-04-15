{ pkgs, ... }:

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

    pulseaudio = {
      support32Bit = true;
    };

    steam-hardware.enable = true;
  };

  nixpkgs.config = {
    # Preferred wine config
    wine = {
      # release = "staging"; # Would be preferred, but full staging wine is not in binary cache.
      build = "wineWow";
    };
  };

  services.ratbagd.enable = true;

  environment.systemPackages = with pkgs; [
#    _20kly
    minecraft
    openclonk
    openjk
    openra
#    openttd
    piper
    steam
    steam-run
    superTuxKart
    warzone2100
    wine
    winetricks
  ];
}
