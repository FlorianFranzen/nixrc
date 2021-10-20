{ nixFlakes }:

nixFlakes.overrideAttrs (old: {
  patches = old.patches ++ [
    ./nix-flakes.self-submodules.patch
  ];
})
