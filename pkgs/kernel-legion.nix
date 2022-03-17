{ lib, buildPackages, fetchurl, perl, buildLinux, nixosTests, ... } @args:

buildLinux (args // rec {
  version = "5.17-rc8";

  # modDirVersion needs to be x.y.z, will always add .0
  modDirVersion = builtins.replaceStrings ["-"] [".0-"] version;

  extraMeta.branch = lib.versions.majorMinor version;

  src = fetchurl {
    url = "https://git.kernel.org/torvalds/t/linux-${version}.tar.gz";
    sha256 = "Mik+V0fnYjx+ofzFW3uzeRggZik1PzjR7lYjhSrUKO0=";
  };

  kernelPatches = [
    { name = "legion7-speaker"; patch = ./kernel-legion.speaker.patch; }
  ];
} // (args.argsOverride or {}))
