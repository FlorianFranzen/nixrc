channels: 

final: prev: 

{
  # Do not reexport packages from unstable 
  __dontExport = true; 

  # Packages to take from unstable
  inherit (channels.unstable) nix wofi zsa-udev-rules;

  hydra-unstable = channels.unstable.hydra-unstable.override {
    # Use same nix for hydra as well.
    inherit (final) nix;
  };
}

