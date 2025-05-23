{ rustPlatform, fetchFromGitHub, pkg-config, dbus }:

rustPlatform.buildRustPackage rec {
  pname = "wscreensaver-bridge";
  version = "0.3";

  src = fetchFromGitHub {
    owner = "kelvie";
    repo = "wscreensaver-bridge";
    rev = "v${version}";
    hash = "sha256-uB5mmuQnGdYtt3Gd/YW6jOgAkTBEbVHy4j41+JPTjL0=";
  };

  cargoHash = "sha256-rQUzm/xieF+EygS5UO60InckHRQJBuTgyWQQsTg7Bu8=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ dbus ];
}
