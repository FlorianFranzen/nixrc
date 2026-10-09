{ stdenv, lib, fetchFromGitHub, cmake, pkg-config, alsa-lib, libevdev, rtaudio, rtmidi }:

stdenv.mkDerivation {
  pname = "traktor-kontrol";
  version = "2023-02-07";

  src = fetchFromGitHub {
    owner = "jmanera";
    repo = "traktor-kontrol-s4-mk1-driver-linux";
    rev = "ba7dda3efae816bd2c2cf5fd3a52bb9f4bc58bec";
    hash = "sha256-YomY/S4jU/0fH6mPyuBiAzMP5YEqWEczofixJIFrutU=";
  };

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ alsa-lib libevdev rtaudio rtmidi ];

  installPhase = ''
    mkdir -p $out/bin $out/share
    cp traktor_kontrol_s4_mk1_driver_linux $out/bin/traktor_kontrol
    cp -r $src/config.json $src/mappings $out/share
  '';
}
