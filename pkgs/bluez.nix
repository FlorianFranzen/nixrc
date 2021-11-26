{ bluez5 }:

bluez5.overrideAttrs (old: {
  # Enable experimental features
  configureFlags = old.configureFlags ++ [ "--enable-experimental" ];
})
