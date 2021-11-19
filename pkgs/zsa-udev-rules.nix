{ zsa-udev-rules, fetchFromGitHub }:

zsa-udev-rules.overrideAttrs (old: rec {
  version = "2.1.3";

  src = fetchFromGitHub {
    owner = "zsa";
    repo = "wally";
    rev = "${version}-linux";
    sha256 = "mZzXKFKlO/jAitnqzfvmIHp46A+R3xt2gOhVC3qN6gM=";
  };
}) 
