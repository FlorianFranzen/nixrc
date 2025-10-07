{ pkgs, ... }:

{
  # Expose various ports via separate virtual devices:
  services.pipewire.extraConfig.pipewire."50-focusrite-scarlett"."context.modules" = [
    # - First microphone on first input
    {
      name = "libpipewire-module-loopback";
      args = {
        "node.description" = "Microphone One";
        "capture.props" = {
          "audio.position" = [ "AUX0" ];
          "node.passive" = true;
          "stream.dont-remix" = true;
          "target.object" =
            "alsa_input.usb-Focusrite_Scarlett_18i16_4th_Gen_S86BQND4902432-00.multichannel-input";
        };
        "playback.props" = {
          "audio.position" = [ "MONO" ];
          "media.class" = "Audio/Source";
          "node.name" = "usb-FS_Microphone_00";
        };
      };
    }
    # - Second microphone on second input
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
          "node.name" = "usb-FS_Microphone_01";
        };
      };
    }
    # - First headphones on second stereo output
    {
      name = "libpipewire-module-loopback";
      args = {
        "node.description" = "Headphone One";
        "capture.props" = {
          "audio.position" = [ "FL" "FR" ];
          "media.class" = "Audio/Sink";
          "node.name" = "usb-FS_Headphone_00";
        };
        "playback.props" = {
          "audio.position" = [ "AUX2" "AUX3" ];
          "node.passive" = true;
          "stream.dont-remix" = true;
          "target.object" =
            "alsa_input.usb-Focusrite_Scarlett_18i16_4th_Gen_S86BQND4902432-00.multichannel-input";
        };
      };
    }
    # - Second headphones on third stereo output
    {
      name = "libpipewire-module-loopback";
      args = {
        "node.description" = "Headphone Two";
        "capture.props" = {
          "audio.position" = [ "FL" "FR" ];
          "media.class" = "Audio/Sink";
          "node.name" = "usb-FS_Headphone_01";
        };
        "playback.props" = {
          "audio.position" = [ "AUX4" "AUX5" ];
          "node.passive" = true;
          "stream.dont-remix" = true;
          "target.object" =
            "alsa_input.usb-Focusrite_Scarlett_18i16_4th_Gen_S86BQND4902432-00.multichannel-input";
        };
      };
    }
  ];

  # Install tooling
  environment.systemPackages = [
    pkgs.fcp-support
    pkgs.alsa-scarlett-gui
  ];

  # Integrate userspace server via udev
  systemd.packages = [ pkgs.fcp-support ];
  services.udev.packages = [ pkgs.fcp-support ];
}
