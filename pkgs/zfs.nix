{
  callPackage,
  nixosTests,
  path,
  ...
}@args:

callPackage "${path}/pkgs/os-specific/linux/zfs/generic.nix" args {
  kernelModuleAttribute = "zfs_unstable";

  kernelMinSupportedMajorMinor = "4.18";
  kernelMaxSupportedMajorMinor = "7.0";

  version = "2.4.1";
  
  hash = "sha256-gapM2PNVOjhwGw6TAZF6QDxLza7oqOf1tpj7q0EN9Vg=";

  # Extra patches for kernel v7.0 support
  extraPatches = [
    ./zfs.setlease.patch
    ./zfs.blk_queue.patch
    ./zfs.posix_acl.patch
    ./zfs.fs_context.patch
    ./zfs.setlease_dir.patch
    ./zfs.inatomic.patch
    ./zfs.mount-options.patch
    ./zfs.meta.patch
  ];

  tests = {
    inherit (nixosTests.zfs) unstable;
  };

  extraLongDescription = ''
    This is a patched version of zfs to support kernel v7.0
  '';
}
