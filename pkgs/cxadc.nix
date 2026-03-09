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
  version = "2026-01-15";

  src = fetchFromGitHub {
    owner = "happycube";
    repo = "cxadc-linux3";
    rev = "c6f3b23e431cdda2e939d73008e643b54bda56b7";
    hash = "sha256-6icpVYvRM+N7DG68wDCPxZ57bDLIp03bn1CEUIUlHa4=";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;
  
  preBuild = ''
    substituteInPlace Makefile \
      --replace "/lib/modules" "${kernel.dev}/lib/modules"
  '';

  installPhase = ''
    mkdir -p $out/lib/modules/${kernel.modDirVersion}/${modPath}
    cp ./${modName}.ko $out/lib/modules/${kernel.modDirVersion}/${modPath}

    mkdir -p $out/lib/udev/rules.d
    cp ./cxadc.rules $out/lib/udev/rules.d/50-cxadc.rules

    mkdir -p $out/lib/modprobe.d
    cp ./cxadc.conf $out/lib/modprobe.d/
  '';
}
