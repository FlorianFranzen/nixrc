{ stdenv, fetchFromGitHub, cmake, libGL, xorg, poco }:

stdenv.mkDerivation rec {
  pname = "libprojectM";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "projectM-visualizer";
    repo = "projectm";
    rev = "v${version}";
    sha256 = "sha256-JRMVXfjpMBdnpU+w9o9aa+yL4mnqEcr/wovme3isM64=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ libGL xorg.libX11 ];

  cmakeFlags = [ "-DENABLE_GLES=ON" ];
}
