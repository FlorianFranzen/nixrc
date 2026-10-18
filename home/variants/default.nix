{ lib, ... }:

{
  # NOTE This file should be as empty as possible, as the default variant
  #      should not really add anything. Theming stays off.
  theme.enable = lib.mkForce false;
  gtk.enable = lib.mkForce false;
}
