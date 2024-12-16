{ fetchFromGitHub
, buildNpmPackage
}:

buildNpmPackage rec {
  pname = "krohnkite";
  version = "0.9.8.4";

  src = fetchFromGitHub {
    owner = "anametologin";
    repo = pname;
    rev = version;
    hash = "sha256-VVHusFuQ/awfFV4izId7VPYCrS8riTavhpB2KpJ9084=";
  };

  npmDepsHash = "sha256-k44SltKLR/Y8qWFCLW2jBWElk9JGn+0azQn0G1f0vuY=";

  dontNpmBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/kwin/scripts/${pname}
    make KWINPKG_DIR=$out/share/kwin/scripts/${pname} PROJECT_REV=fa10f8c all
    runHook postInstall
  '';
}
