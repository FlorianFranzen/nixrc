{ bumblebee }:

bumblebee.overrideAttrs (old: rec {
  name = "${old.pname}-${version}";
  version = "${old.version}-amd";

  patches = old.patches ++ [ ./bumblebee.internal_amd.patch ];
})
