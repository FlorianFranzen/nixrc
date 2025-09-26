{ pkgs, ... }:

let
  focusrite-scarlett-conf = pkgs.writeTextDir "share/pipewire/pipewire.conf.d/50-focusrite-scarlett.conf" ''
    context.modules = [
    {   name = libpipewire-module-loopback
        args = {
          node.description = "Microphone One"
          capture.props = {
            audio.position = [ AUX0 ]
            node.passive = true
            stream.dont-remix = true
            target.object = "alsa_input.usb-Focusrite_Scarlett_18i16_4th_Gen_S86BQND4902432-00.multichannel-input"
          }
          playback.props = {
            audio.position = [ MONO ]
            media.class = "Audio/Source"
            node.name = "usb-FS_Mono-00"
          }
        }
    }
    ]
  '';
in
{
  # Expose first microphone via virtual device
  services.pipewire.configPackages = [
    focusrite-scarlett-conf
  ];

  # Attempt to expose second mic as well
  services.pipewire.extraConfig.pipewire."51-focusrite-scarlett" = {
    "context.modules" = [
      {
        name = "libpipewire-module-loopback";
        args = {
          "node.description" = "Microphone Two";
          "capture.props" = {
            "audio.position" = [ "AUX1" ];
            "node.passive" = true;
            "stream.dont-remix" = true;
            "target.object" =
              "alsa_input.usb-Focusrite_Scarlett_18i16_4th_Gen_S86BQND4902432-00.multichannel-input";
          };
          "playback.props" = {
            "audio.position" = [ "MONO" ];
            "media.class" = "Audio/Source";
            "node.name" = "usb-FS_Mono_01";
          };
        };
      }
    ];
  };

  # Install tooling
  environment.systemPackages = [
    pkgs.fcp-support
    pkgs.alsa-scarlett-gui
  ];

  # Integrate userspace server via udev
  systemd.packages = [ pkgs.fcp-support ];
  services.udev.packages = [ pkgs.fcp-support ];
}
