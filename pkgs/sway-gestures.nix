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
      sha256 = "FA9v7ZmXLTLDflwSSadXRszoEKrV4PaJV/Frk4PPj0o=";
    };
  });

  sway = super.sway.override {
    inherit (self) sway-unwrapped;
  };
}
