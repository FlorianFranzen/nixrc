let
  common = {
    icons = "material-nf";
  };
in {
  programs.i3status-rust = {
    enable = true;

    bars = {
      # Top bar with all important hardware info
      top = common // {
        blocks = [
          {
            block = "focused_window";
            max_width = 50;
            show_marks = "visible";
          }
          {
            block = "sound";
            max_vol = 100;
          }
          {
            block = "sound";
            device_kind = "source";
            format = "";
          }
          {
            block = "cpu";
            interval = 5;
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
            warning = 20.0;
            alert = 10.0;
          }
          {
            block = "battery";
            interval = 15;
            format = "{percentage} {time}";
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
            block = "bluetooth";
            mac = "38:18:4C:D3:F5:A0";
            format = "Headphones";
          }
          {
            block = "music";
            max_width = 50;
            dynamic_width = true;
            buttons = [ "play" ];
          }
        ];
      };
    };
  };
}
