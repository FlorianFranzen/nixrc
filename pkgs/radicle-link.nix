{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, cmake
}:

rustPlatform.buildRustPackage rec {
  pname = "radicle-link";
  version = "2022-07-12";

  src = fetchFromGitHub {
    owner = "radicle-dev";
    repo = pname;
    rev = "cycle/${version}";
    sha256 = "nOiNXBnBnnTKAU+B0RzYX4yB4uEtVYeZeyX4Hzjaa9c=";
  };

  sourceRoot = "source/bins";

  cargoSha256 = "sha256-yrLeEn0UxY/9ZZq2wG4J3FI53SV3Q6XAqs8C+v2VuVs=";

  nativeBuildInputs = [
    cmake
  ];

  meta = {
    description = "The second iteration of the Radicle code collaboration protocol.";
    homepage = "https://radicle.xyz";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ florianfranzen ];
    platforms = lib.platforms.unix;
    mainProgram = "lnk";
  };
}
