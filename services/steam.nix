{ config, pkgs, ... }:

{
  nixpkgs.config = {
    allowUnfree = true;
  };

  # Enable kodi media server
  services.xserver = {
    enable = true;

    libinput.enable = true;

    displayManager.auto = {
      enable = true;
      user = "steam";
    };

    desktopManager.steam.enable = true;
    desktopManager.steam.package = pkgs.steamos-compositor-plus;
  };

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # 32bit video and audio support
  hardware.opengl.driSupport32Bit = true;
  hardware.pulseaudio.support32Bit = true;

  users.users.steam = {
    isSystemUser = true;
    home = "/data/steam";
  };
}
