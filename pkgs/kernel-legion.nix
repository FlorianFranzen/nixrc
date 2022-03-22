{ lib, buildPackages, fetchurl, perl, buildLinux, nixosTests, ... } @args:

buildLinux (args // rec {
  version = "5.17";

  modDirVersion = "${version}.0";

  extraMeta.branch = lib.versions.majorMinor version;

  src = fetchurl {
    url = "https://git.kernel.org/torvalds/t/linux-${version}.tar.gz";
    sha256 = "9YM4xbBjFFWaJpr+cLM7mwt1zC/l6KU3rCn3DKpuSJs=";
  };

  kernelPatches = [
    { name = "legion7-speaker"; patch = ./kernel-legion.speaker.patch; }
  ];
} // (args.argsOverride or {}))
