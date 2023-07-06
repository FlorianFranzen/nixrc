{ stdenv, lib, fetchFromGitHub, wrapQtAppsHook, qmake, pkg-config, qtbase, gtk2, xorg }:

stdenv.mkDerivation rec {
  pname = "qt6gtk2";
  version = "2022-05-19";

  src = fetchFromGitHub {
    owner = "trialuser02";
    repo = pname;
    rev = "2a21a8ad59a76e6928fae1699c830ca24fb2461c";
    hash = "sha256-b9hM08GMuyQ3cMnndUrWZGsUPGTbYjhWxrKgX74Uqfk=";
  };

  nativeBuildInputs = [ qmake pkg-config wrapQtAppsHook ];
  buildInputs = [ qtbase gtk2 xorg.libX11 ];

  qmakeFlags = [ "PLUGINDIR=${placeholder "out"}/lib/qt-6/plugins" ];
}
