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

stdenv.mkDerivation {
  pname = "fcp-support";
  version = "2025-04-10";

  src = fetchFromGitHub {
    owner = "geoffreybennett";
    repo = "fcp-support";
    rev = "edae476e670254083741a0a14bc7a482d95a5ccb";
    hash = "sha256-iokiRxtHdlNHau5TzFBmr7LFlrBUWG9NIZNXSmVL/DM=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    alsa-lib
    json_c
    openssl
    systemdLibs
    zlib
  ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];
}
