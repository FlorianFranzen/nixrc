{ fetchFromGitHub
, buildNpmPackage
}:

buildNpmPackage rec {
  pname = "krohnkite";
  version = "0.9.8.3";

  src = fetchFromGitHub {
    owner = "anametologin";
    repo = pname;
    rev = version;
    hash = "sha256-PiGpYOKvBpwkPfDWHlOhq7dwyBYzfzfJVURiEC1a78g=";
  };

  npmDepsHash = "sha256-IUGRxDCn/aEebCgDPElEPKOxfoYmLoFHVROkTJpNISY=";

  dontNpmBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/kwin/scripts/${pname}
    make KWINPKG_DIR=$out/share/kwin/scripts/${pname} PROJECT_REV=fa10f8c all
    runHook postInstall
  '';
}
