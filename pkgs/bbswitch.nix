{ bbswitch, kernel }:

bbswitch.overrideAttrs (old: rec {
  pname = "bbswitch";
  version = "0.8-amd";

  name = "${pname}-${version}-${kernel.version}";

  patches = old.patches ++ [ 
    ./bbswitch.internal_amd.patch 
  ];

  meta.broken = false;
})
