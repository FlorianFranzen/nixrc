{ pkgs, ... }:

let
  common = {
    icons = "material-nf";
    theme = "modern";
  };

  in_terminal = command: "${pkgs.alacritty}/bin/alacritty --command '${command}'";
in {
  programs.i3status-rust = {
    enable = true;

    bars = {
      # Top bar with all important hardware info
      top = common // {
        blocks = [
          {
            block = "focused_window";
            max_width = 100;
            show_marks = "visible";
          }
          {
            block = "cpu";
            interval = 5;
            on_click = in_terminal "${pkgs.bottom}/bin/btm";
          }
          {
            block = "memory";
            interval = 5;
            format_mem = "{mem_used_percents}";
            format_swap = "{swap_used_percents}";
          }
          {
            block = "disk_space";
            path = "/";
            format = "{icon} {available} {percentage}";
            interval = 20;
            warning = 25.0;
            alert = 10.0;
          }
          {
            block = "net";
            format = "{ssid} {ip}";
            on_click = in_terminal "${pkgs.iwd}/bin/iwctl";
          }
          {
            block = "battery";
            driver = "upower";
            format = "{percentage} {time}";
            allow_missing = true;
            hide_missing = true;
          }
          {
            block = "time";
            interval = 60;
            format = "%a %d.%m.%Y %R";
          }
        ];
      };
      # Bottom bar with secondary info
      bottom = common // {
        blocks = [
          {
            block = "sound";
            max_vol = 100;
            format = "{output_description} {volume}";
            on_click = "${pkgs.pavucontrol}/bin/pavucontrol --tab=3";
          }
          {
            block = "sound";
            max_vol = 50;
            device_kind = "source";
            on_click = "${pkgs.pavucontrol}/bin/pavucontrol --tab=4";
          }
          {
            block = "bluetooth";
            mac = "38:18:4C:D3:F5:A0";
            format = "Headphones {percentage}";
            format_unavailable = "Headphones?";
          }
          {
            block = "music";
            max_width = 50;
            dynamic_width = true;
            buttons = [ "prev" "play" "next" ];
          }
        ];
      };
    };
  };
}
