{ stdenv, fetchFromGitHub, cmake, poco, SDL2, utf8proc, libprojectM }:

let
  presets = fetchFromGitHub {
    owner = "projectM-visualizer";
    repo = "presets-cream-of-the-crop";
    rev = "4e0bf9f0ca92dcdf00b049701e20ef57b1d2c406";
    sha256 = "sha256-a8FVqI9yb5KWP4M5T6OLX+SsHT6qxhHUsMJ6witf+ZA=";
  };

  textures = fetchFromGitHub {
    owner = "projectM-visualizer";
    repo = "presets-milkdrop-texture-pack";
    rev = "ff8edf2a8fa07e55ad562f1af97076526c484f7d";
    sha256 = "sha256-0PNCmaC+C5g2nFv4Oy7LtBfLj1NkyfhDBWSM17ilbpE=";
  };

in stdenv.mkDerivation {
  name = "projectm-sdl2";
  version = "2025-03-17";

  src = fetchFromGitHub {
    owner = "projectM-visualizer";
    repo = "frontend-sdl-cpp";
    rev = "080e48b303fe9d7eebaba6d266ddef0543bba0d3";
    sha256 = "sha256-5thnZhw22U2IVn6VNDEIw1fEaTnTwJv8pkgAdWdrHu8=";
    fetchSubmodules = true;
  };

  patches = [
    ./projectM-sdl2.patch
  ];

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [ 
    poco
    SDL2
    utf8proc
    libprojectM 
  ];

  cmakeFlags = [
    "-DDEFAULT_PRESETS_PATH=${presets}"
    "-DDEFAULT_TEXTURES_PATH=${textures}/textures"
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp src/projectMSDL src/projectMSDL.properties $out/bin
  '';
}
