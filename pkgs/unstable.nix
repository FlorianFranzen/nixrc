channels: 

final: prev: 

{
  # Do not reexport packages from unstable 
  __dontExport = true; 

  # Packages to take from unstable
  inherit (channels.unstable) wofi zsa-udev-rules;
}

