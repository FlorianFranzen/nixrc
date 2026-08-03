{ buildGoModule, fetchFromGitHub, hidapi, udev, ... }:

buildGoModule (finalAttrs: {
  pname = "gbmonctl";
  version = "2025-12-04";

  src = fetchFromGitHub {
    owner = "kelvie";
    repo = "gbmonctl";
    rev = "6652440de2aa1413be0a511b49af52f5c7456cae";
    hash = "sha256-KYeNYmzMV6CoKtxIKLVR3cKzqLC9ex/FGBak8CZNSC0=";
  };

  vendorHash = "sha256-cEqpEaX4eJ/6um9qbw/kzg9/vesOWmdiHzZ7IodVV9c=";

  buildInputs = [ hidapi udev ];
})

