{ rtw89, fetchFromGitHub }:

rtw89.overrideAttrs (old: rec {
  name = "${old.pname}-${version}";
  version = "v7";

  src = fetchFromGitHub {
    owner = "FlorianFranzen";
    repo = "rtw89";
    rev = version;
    sha256 = "+akuyrsiCUm6O9IogPj3d9r6s0UQoSr+3E2dCloCmSo=";
  };
})
