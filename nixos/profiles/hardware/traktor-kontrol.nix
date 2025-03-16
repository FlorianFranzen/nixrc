{ pkgs, ... }:

{
  hardware.alsa.config = ''
    pcm.TraktorS4InputCOutputMain { type plug; slave.pcm "hw:TraktorKontrolS,0,0"; }
    pcm.TraktorS4InputDOutputHeadphones { type plug; slave.pcm "hw:TraktorKontrolS,0,1"; }
  '';

  environment.systemPackages = with pkgs; [ mixxx traktor-kontrol ];
}
