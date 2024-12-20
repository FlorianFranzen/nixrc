{ stdenv
, lib
, fetchFromGitHub
, linuxPackages
, kernel ? linuxPackages.kernel
}:

let
  modName = "cxadc";
  modPath = "misc"; 
in stdenv.mkDerivation rec {
  name = "${modName}-${version}-module-${kernel.modDirVersion}";
  version = "2024-11-19";

  src = fetchFromGitHub {
    owner = "happycube";
    repo = "cxadc-linux3";
    rev = "6ffc17cfb504b8d71da6fa84891e706558af3d40";
    hash = "sha256-9k5uiRdhTdZs+SqluvefJL9z+9t+KjpPyZQTcv0ko3E=";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;
  
  preBuild = ''
    substituteInPlace Makefile \
      --replace "/lib/modules" "${kernel.dev}/lib/modules"
  '';

  makeFlags = kernel.makeFlags;

  installPhase = ''
    mkdir -p $out/lib/modules/${kernel.modDirVersion}/${modPath}
    cp ./${modName}.ko $out/lib/modules/${kernel.modDirVersion}/${modPath}
  '';
}
