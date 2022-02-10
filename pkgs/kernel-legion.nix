{ lib, buildPackages, fetchurl, perl, buildLinux, nixosTests, ... } @args:

buildLinux (args // rec {
  version = "5.17-rc3";

  # modDirVersion needs to be x.y.z, will always add .0
  modDirVersion = builtins.replaceStrings ["-"] [".0-"] version;

  extraMeta.branch = lib.versions.majorMinor version;

  src = fetchurl {
    url = "https://git.kernel.org/torvalds/t/linux-${version}.tar.gz";
    sha256 = "Ibe32H2rd33A4n3pm9FneXt3S+CLWU84SDnlT9Yswhc=";
  };

  kernelPatches = [
    { name = "legion7-speaker"; patch = ./kernel-legion.speaker.patch; }
  ];
} // (args.argsOverride or {}))
