{
  stdenv,
  fetchFromGitHub,
  pkg-config,
  alsa-lib,
  json_c,
  openssl,
  systemdLibs,
  zlib,
}:

stdenv.mkDerivation (final: {
  pname = "fcp-support";
  version = "1.0beta1";

  src = fetchFromGitHub {
    owner = "geoffreybennett";
    repo = "fcp-support";
    rev = final.version;
    hash = "sha256-pyGtQkbaroWIXRVrSeR+1oeOJrjBfOUM7El0PUsr6mQ=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    alsa-lib
    json_c
    openssl
    systemdLibs
    zlib
  ];

  makeFlags = [ "DESTDIR=${placeholder "out"}" "PREFIX=/" ];
})
