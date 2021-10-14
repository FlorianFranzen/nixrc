self: super:

let
  extendKernel = kpkgs: kpkgs.extend (kself: ksuper: {
    bbswitch = ksuper.callPackage ./bbswitch.nix { linuxPackages = kpkgs; };
    rtw89 = ksuper.callPackage ./rtw89.nix { linuxPackages = kpkgs; };
  });
in {
  linuxPackages_latest = extendKernel super.linuxPackages_latest;

  linuxPackages = extendKernel super.linuxPackages;
}
