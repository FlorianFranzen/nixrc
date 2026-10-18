{ config, lib, ... }:

let
  theme = config.theme;
  p = theme.palette.dark;

  escape = lib.replaceStrings [ " " ] [ "\\ " ];
in
{
  config = lib.mkIf theme.enable {
    wayland.windowManager.sway.config = {
      colors =
        let
          default = {
            background = p.background;
            text = p.foreground;
            indicator = p.tertiary;
          };
        in
        {
          focused = default // { border = p.accent; childBorder = p.accent; };
          focusedInactive = default // { border = p.outline; childBorder = p.outline; };
          placeholder = default // { border = p.surfaceVariant; childBorder = p.surfaceVariant; };
          unfocused = default // { border = p.surfaceVariant; childBorder = p.surfaceVariant; };
          urgent = default // { border = p.red; childBorder = p.red; };
          background = p.background;
        };

      output."*".background = lib.mkIf (theme.wallpaper.dark != null) "${theme.wallpaper.dark} fill";

      seat."*".xcursor_theme = lib.mkIf (theme.cursorTheme != null) (escape theme.cursorTheme.name);
    };

    services.mako.settings = {
      background-color = "${p.background}f2";
      border-color = "${p.outline}f2";
      progress-color = "${p.tertiary}f2";
      text-color = "${p.foreground}f2";

      "urgency=low".border-color = "${p.surfaceVariant}f2";
      "urgency=normal".border-color = "${p.accent}f2";
      "urgency=high" = {
        border-color = "${p.red}f2";
        default-timeout = 0;
      };
    };

    services.wob.settings = {
      "" = {
        border_color = "${lib.removePrefix "#" p.outline}f2";
        background_color = "${lib.removePrefix "#" p.background}f2";
        bar_color = "${lib.removePrefix "#" p.accent}f2";
      };
      "style.muted".bar_color = "${lib.removePrefix "#" p.brightBlack}f2";
    };

    programs.i3status-rust.bars.top.theme = theme.i3status;
    programs.i3status-rust.bars.bottom.theme = theme.i3status;
  };
}
