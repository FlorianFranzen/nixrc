{ buildGoModule, fetchFromGitHub, hidapi, udev, ... }:

buildGoModule (finalAttrs: {
  pname = "gbmonctl";
  version = "2026-08-04";

  src = fetchFromGitHub {
    owner = "kelvie";
    repo = "gbmonctl";
    rev = "07851eac191188ebf9e3db4a71776728c7372b5c";
    hash = "sha256-YQ6HUnW3BHYNjHHzkID300BiSEPOJXiLAoBx5Svkpuw=";
  };

  vendorHash = "sha256-cEqpEaX4eJ/6um9qbw/kzg9/vesOWmdiHzZ7IodVV9c=";

  buildInputs = [ hidapi udev ];

  postInstall = ''
    mkdir -p $out/lib/udev/rules.d
    cp 99-gigabyte-monitor.rules $out/lib/udev/rules.d/
  '';
})

