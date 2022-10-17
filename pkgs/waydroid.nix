{ stdenv
, lib
, fetchFromGitHub
, python3Packages
, dnsmasq
, gawk
, getent
, kmod
, lxc
, iproute2
, iptables
, nftables
, util-linux
, which
, xclip
}:

python3Packages.buildPythonApplication rec {
  pname = "waydroid";
  version = "1.3.3";
  format = "other";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "sha256-av1kcOSViUV2jsFiTE21N6sAJIL6K+zKkpPHjx6iYVk=";
  };

  propagatedBuildInputs = with python3Packages; [
    gbinder-python
    pyclip
    pygobject3
  ];

  dontUseSetuptoolsBuild = true;
  dontUsePipInstall = true;
  dontUseSetuptoolsCheck = true;
  dontWrapPythonPrograms = true;

  installPhase = ''
    make install PREFIX=$out USE_SYSTEMD=0 USE_NFTABLES=1

    wrapProgram $out/lib/waydroid/data/scripts/waydroid-net.sh \
       --prefix PATH ":" ${lib.makeBinPath [ dnsmasq getent iproute2 iptables nftables ]}

    wrapPythonProgramsIn $out/lib/waydroid/ "${lib.concatStringsSep " " [
      "$out"
      python3Packages.gbinder-python
      python3Packages.pygobject3
      python3Packages.pyclip
      kmod
      lxc
      gawk
      util-linux
      which
      xclip
    ]}"
  '';
}
