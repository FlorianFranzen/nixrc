{ bluez }:

bluez.overrideAttrs (old: {
  # Allow enabling experimental features from config file
  patches = [
    ./bluez.experimental.patch
  ];

  # Enable experimental features
  configureFlags = old.configureFlags ++ [ "--enable-experimental" ];
})
