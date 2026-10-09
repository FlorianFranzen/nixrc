{ stdenv
, fetchFromGitHub
, linuxPackages
, kernel ? linuxPackages.kernel
}:

let
  modName = "atlantic";
  modPath = "extra";
in stdenv.mkDerivation rec {
  name = "${modName}-${version}-module-${kernel.modDirVersion}";
  version = "2.5.16";

  src = fetchFromGitHub {
    owner = "FlorianFranzen";
    repo = "atlantic";
    rev = "v${version}";
    hash = "sha256-Fnd3JPvIHAellV0yntRt8TZuPEJSDFVWWbx5p0RP4Nw=";
  };

  # Disable LRO at compile time, as it breaks interface if disabled at runtime
  patches = [ ./atlantic.lro.patch ];

  nativeBuildInputs = kernel.moduleBuildDependencies;

  KDIR = "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build";

  installPhase = ''
    mkdir -p $out/lib/modules/${kernel.modDirVersion}/${modPath}
    cp ./${modName}.ko $out/lib/modules/${kernel.modDirVersion}/${modPath}
  '';
}
