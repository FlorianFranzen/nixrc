{ pkgs, ... }:

{
  # Enable pipewire
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  # Enable pulseaudio clients
  nixpkgs.config = {
    pulseaudio = true;
  };

  environment.systemPackages = with pkgs; [
    helvum
    pulseaudio # for pactl
    pavucontrol
  ];
}
