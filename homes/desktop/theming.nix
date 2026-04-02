{ config, ... }:

{
  # Enable gtk theming by default, to be customized in variants
  gtk.enable = true;

  # Use default gtk theme for gtk4 too
  gtk.gtk4.theme = config.gtk.theme;
}
