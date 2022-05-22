self: super:

{
  # Sway, but with gestures
  sway-unwrapped = super.sway-unwrapped.overrideAttrs (old: rec {
    version = "1.8.0-gestures";
    name = "${old.pname}-${version}";

    src = super.fetchFromGitHub {
      owner = "FlorianFranzen";
      repo = "sway";
      rev = "pointer-gestures";
      sha256 = "kKvYajLyyRKZ1Quw5VS2Fj64lfE1rNv2tQWAPYngWH4=";
    };
  });

  sway = super.sway.override {
    inherit (self) sway-unwrapped;
  };
}
