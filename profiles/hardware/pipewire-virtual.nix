{ pkgs, ... }:

{
  # Add two purely virtual interfaces to simplify streaming and recording
  services.pipewire.extraConfig.pipewire."69-virtual-stereo"."context.modules" = [
    {
      name = "libpipewire-module-loopback";
      args = {
        "node.description" = "Virtual Sink";
        "audio.position" = [ "FL" "FR" ];
        "capture.props" = {
          "media.class" = "Audio/Sink";
          "node.name" = "virt-sink";
        };
      };
    }
  ];
}
