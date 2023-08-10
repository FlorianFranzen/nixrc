{ stdenv
, linuxPackages
, kernel ? linuxPackages.kernel
}:

let

  modName = "nct6775";
  modPath = "drivers/hwmon";

in stdenv.mkDerivation rec {
  name = "${modName}-${version}-module-${kernel.modDirVersion}";
  version = "${kernel.version}+compat";

  inherit (kernel) src;

  patches = [
    # Add some upcoming patches
    ./nct6775.upstream.patch
    #./nct6775.reading.patch
    #./nct6775.temp.patch
  ];

  nativeBuildInputs = [ kernel.moduleBuildDependencies ];

  makeFlags = [ 
    "-C" "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build" 
    "M=$(PWD)/${modPath}" "${modName}.ko" "${modName}-core.ko" 
  ];

  installPhase = ''
    mkdir -p $out/lib/modules/${kernel.modDirVersion}/${modPath}
    cp ./${modPath}/${modName}.ko $out/lib/modules/${kernel.modDirVersion}/${modPath}
    cp ./${modPath}/${modName}-core.ko $out/lib/modules/${kernel.modDirVersion}/${modPath}
  '';
}
