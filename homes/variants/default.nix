{ lib, ... }:

{
  # NOTE This file should be as empty as possible, as the default variant 
  #      should not ready add anything. But some tuning might be necessary
  #      depending on how variants are being used, e.g. for theming. 

  # Forcefully disable pywal theme engine in default variant
  pywal.enable = lib.mkForce true;
}
