{ xwayland, fetchurl }:

xwayland.overrideAttrs (old: rec {
  version = "21.1.2";

  name = "${old.pname}-${version}";

  src = fetchurl {
    url = "mirror://xorg/individual/xserver/${old.pname}-${version}.tar.xz";
    sha256 = "sha256-uBy91a1guLetjD7MfsKijJvwIUSGcHNc67UB8Ivr0Ys=";
  };
})
