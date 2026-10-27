{ pkgs, ... }:

{
  # Enable pipewire
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  environment.systemPackages = with pkgs; [
    crosspipe
    pulseaudio # for pactl
    pavucontrol
  ];
}
