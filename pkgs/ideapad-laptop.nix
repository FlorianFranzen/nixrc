{ stdenv
, linuxPackages
, kernel ? linuxPackages.kernel
}:

let

  modName = "ideapad-laptop";
  modPath = "drivers/platform/x86"; 

in stdenv.mkDerivation rec {
  name = "${modName}-${version}-module-${kernel.modDirVersion}";
  version = "${kernel.version}+legion";

  inherit (kernel) src;

  patches = [
    ./ideapad-laptop.no_rfkill.patch  
  ];

  makeFlags = [ 
    "-C" "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build" 
    "M=$(PWD)/${modPath}" "${modName}.ko" 
  ];

  installPhase = ''
    mkdir -p $out/lib/modules/${kernel.modDirVersion}/${modPath}
    cp ./${modPath}/${modName}.ko $out/lib/modules/${kernel.modDirVersion}/${modPath}
  '';
}
