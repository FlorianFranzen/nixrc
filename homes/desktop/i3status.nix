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
            format = "{ $title |}{$visible_marks |}";
          }
          {
            block = "cpu";
            format = " $icon $utilization ";
            format_alt = " $icon $barchart ";
            merge_with_next = true;
            click = [{
              button = "right";
              cmd = "${terminal} ${pkgs.bottom}/bin/btm";
            }];
          }
          {
            block = "memory";
            format = " $icon $mem_used_percents ";
            format_alt = " $icon_swap $swap_used_percents ";
            merge_with_next = true;
          }
          {
            block = "temperature";
            chip = "k10temp-*";
          }
          {
            block = "amd_gpu";
            format = " $icon $utilization $vram_used_percents ";
            if_command = "compgen -G '/sys/module/amdgpu/drivers/pci:amdgpu/0000:*'";
            merge_with_next = true;
          }
          {
            block = "temperature";
            chip = "amdgpu-*";
            if_command = "compgen -G '/sys/module/amdgpu/drivers/pci:amdgpu/0000:*'";
          }
          {
            block = "nvidia_gpu";
            interval = 5;
            if_command = "compgen -G '/sys/module/nvidia/drivers/pci:nvidia/0000:*'";
          }
          {
            block = "disk_space";
            path = "/";
            format = " $icon $available.eng(p:Gi,force_prefix:true) $percentage ";
            click = [{ button = "right"; cmd = "update"; }];
          }
          {
            block = "battery";
            driver = "upower";
            format = " $icon $percentage $time ";
            if_command = "test -e /sys/class/power_supply/BAT0";
          }
          {
            block = "time";
            interval = 10;
            format = " $icon $timestamp.datetime(f:'%a %d.%m.%Y %R') ";
          }
        ];
      };
      # Bottom bar with secondary info
      bottom = common // {
        blocks = [
          {
            block = "music";
            format = "{ $icon $combo $prev $play $next |}";
          }   
          {
            block = "sound";
            max_vol = 100;
            format = " $icon $output_description.str(max_w:20){ $volume|} ";
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
          }
          {
            block = "net";
            format = " $icon {$ssid ($signal_strength $frequency)|$device} ^icon_net_down $speed_down.eng(prefix:K) ^icon_net_up $speed_up.eng(prefix:K) ";
            format_alt = " $icon $ip $ipv6 ";
            click = [{
              button = "right";
              cmd = "${terminal} ${pkgs.iwd}/bin/iwctl";
            }];
          }
        ];
      };
    };
  };
}
