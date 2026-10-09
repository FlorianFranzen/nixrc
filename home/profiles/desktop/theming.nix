{ config, ... }:

{
  # Enable gtk theming by default, to be customized in variants
  gtk.enable = true;

  # Avoid gtk2 rc file conflicts
  gtk.gtk2.force = true;

  # Use default gtk theme for gtk4 too
  gtk.gtk4.theme = config.gtk.theme;
}
