{ stdenv
, lib
, fetchFromGitHub
, linuxPackages
, kernel ? linuxPackages.kernel
}:

let
  modName = "zenergy";
  modPath = "misc"; 
in stdenv.mkDerivation rec {
  name = "${modName}-${version}-module-${kernel.modDirVersion}";
  version = "2024-05-19";

  src = fetchFromGitHub {
    owner = "boukehaarsma23";
    repo = "zenergy";
    rev = "d65592b3c9d171ba70e6017e0827191214d81937";
    hash = "sha256-10hiUHJvLTG3WGrr4WXMo/mCoJGFqWk2l5PryjNhcHg=";
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
