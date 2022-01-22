{ nixUnstable, fetchFromGitHub }:

nixUnstable.overrideAttrs (old: {
  src = fetchFromGitHub {
    owner = "FlorianFranzen";
    repo = "nix";
    rev = "submodules";
    sha256 = "A6FKD0ahoswKPp4TCXKcHdgxAW1wVE4SM/KeiyyrvpE=";
  };

  patches = null;
})
