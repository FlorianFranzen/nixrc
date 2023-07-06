{ zeal-qt6, fetchFromGitHub, qt6 }:

zeal-qt6.overrideAttrs (old: {
  # Apperently supporting wayland in qt6 by default is to bloaty for nixpkgs
  buildInputs = old.buildInputs ++ [ qt6.qtwayland ];
  #qtWrapperArgs = [ ''--set QT_AUTO_SCREEN_SCALE_FACTOR 0'' ];
})
