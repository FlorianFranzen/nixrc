{ stdenv, fetchFromGitHub, cmake, libGL, xorg, poco }:

stdenv.mkDerivation rec {
  pname = "libprojectM";
  version = "4.1.4";

  src = fetchFromGitHub {
    owner = "projectM-visualizer";
    repo = "projectm";
    rev = "v${version}";
    sha256 = "sha256-gf1k9iSDARp6/M2/Po1wdOEY6y/QG2nq5uhSFU6bxAM=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ libGL xorg.libX11 ];

  cmakeFlags = [ "-DENABLE_GLES=ON" ];
}
