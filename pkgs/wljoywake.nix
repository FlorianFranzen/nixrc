{ stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, wayland
, wayland-scanner
, wayland-protocols
, udev
, lib }:

stdenv.mkDerivation rec {
  pname = "wljoywake";
  version = "0.3";

  src = fetchFromGitHub {
    owner = "nowrep";
    repo = "wljoywake";
    rev = "v${version}";
    hash = "sha256-zSYNfsFjswaSXZPlIDMDC87NK/6AKtArHBeWCWDDR3E=";
  };

  nativeBuildInputs = [ meson ninja pkg-config ];
  buildInputs = [
    wayland
    wayland-scanner
    wayland-protocols
    udev
  ];
}
