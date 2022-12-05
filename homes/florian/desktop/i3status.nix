{ config, pkgs, ... }:

let
  common = {
    icons = "material-nf";
  };

  terminal = config.wayland.windowManager.sway.config.terminal;
in {

  programs.i3status-rust = {
    enable = true;

    bars = {
      # Top bar with all important hardware info
      top = common // {
        blocks = [
          {
            block = "focused_window";
            format = "{$title|}{ $visible_marks|}";
          }
          {
            block = "cpu";
            interval = 5;
            click = [
              {
                button = "left";
                cmd = "${terminal} ${pkgs.bottom}/bin/btm";
              }
              {
                button = "right";
                cmd = "${terminal} ${pkgs.s-tui}/bin/s-tui";
              }
            ];
          }
          {
            block = "memory";
            interval = 5;
            format = "$mem_used_percents";
            format_alt = "$swap_used_percents";
          }
          {
            block = "disk_space";
            path = "/";
            format = "$available $percentage";
            interval = 15;
            warning = 25.0;
            alert = 10.0;
          }
          {
            block = "battery";
            driver = "upower";
            format = "$percentage $time";
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
            block = "music";
            format = "{$combo |}$prev $play $next";
            hide_when_empty = true;
          }   
          {
            block = "sound";
            max_vol = 100;
            format = "$output_description.rot-str(20){ $volume|}";
            click = [{
              button = "left";
              cmd = "${pkgs.pavucontrol}/bin/pavucontrol --tab=3";
            }];
          }
          {
            block = "sound";
            max_vol = 100;
            device_kind = "source";
            click = [{
              button = "left";
              cmd = "${pkgs.pavucontrol}/bin/pavucontrol --tab=4";
            }];
          }
          {
            block = "bluetooth";
            mac = "38:18:4C:D3:F5:A0";
            format = "Headphones{ $percentage|}";
          }
          {
            block = "net";
            format = "{$ssid ($signal_strength $frequency)|$device}";
            click = [{
              button = "left";
              cmd = "${terminal} ${pkgs.iwd}/bin/iwctl";
            }];
          }
        ];
      };
    };
  };
}
