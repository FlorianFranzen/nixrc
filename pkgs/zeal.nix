{ zeal, fetchFromGitHub }:

zeal.overrideAttrs (_: {
  src = fetchFromGitHub {
    owner = "zealdocs";
    repo = "zeal";
    rev = "00d4b9ca5bf4588629939cca9d602a3dbd6a8525";
    sha256 = "kTc1A8FMW1DCzXcR4cu+0FTQ1TNSttAPEqR2p15UROY=";
  };

  qtWrapperArgs = [ ''--set QT_AUTO_SCREEN_SCALE_FACTOR 0'' ];
})
