{ projectm-sdl-cpp, fetchFromGitHub }:

projectm-sdl-cpp.overrideAttrs (old:
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
in {
  cmakeFlags = old.cmakeFlags ++ [
    "-DDEFAULT_CONFIG_PATH=${placeholder "out"}/share/projectMSDL"
    "-DDEFAULT_PRESETS_PATH=${presets}"
    "-DDEFAULT_TEXTURES_PATH=${textures}/textures"
  ];
})
