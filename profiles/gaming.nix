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
      release = "staging";
      build = "wineWow";
    };
  };

  environment.systemPackages = with pkgs; [
#    _20kly
    minecraft
    openclonk
    openra
#    openttd
    steam
    steam-run
    superTuxKart
    warzone2100
  ];
}
