{ swaylock-effects, fetchFromGitHub }:

swaylock-effects.overrideAttrs (_: {
  version = "2021-10-10";

  src = fetchFromGitHub {
    owner = "mortie";
    repo = "swaylock-effects";
    rev = "a8fc557b86e70f2f7a30ca9ff9b3124f89e7f204";
    sha256 = "GN+cxzC11Dk1nN9wVWIyv+rCrg4yaHnCePRYS1c4JTk=";
  };
})
