self: super:

let
  extendKernel = kpkgs: kpkgs.extend (kself: ksuper: {
    bbswitch = ksuper.callPackage ./bbswitch.nix { linuxPackages = kpkgs; };
    rtw89 = ksuper.callPackage ./rtw89.nix { linuxPackages = kpkgs; };
  });

  enableOzoneWayland = drv: self.symlinkJoin {
    inherit (drv) name version meta;
    nativeBuildInputs = [ self.makeWrapper ];
    paths = [ drv ];

    postBuild = ''
      for bin in $out/bin/*; do
        echo "- wrapping $bin..."
        wrapProgram "$bin" \
          --add-flags "--enable-features=UseOzonePlatform,WebRTCPipeWireCapturer --ozone-platform=wayland"
      done
    '';
  };
in {
  linuxPackages_latest = extendKernel super.linuxPackages_latest;
  linuxPackages = extendKernel super.linuxPackages;

  bluez-experimental = super.callPackage ./bluez.nix {};

  nixFlakes = super.callPackage ./nix-flakes.nix { nixFlakes = super.nixFlakes; }; 

  element-desktop-wayland = enableOzoneWayland super.element-desktop;
  chromium-wayland = enableOzoneWayland super.chromium;
  signal-desktop-wayland = enableOzoneWayland super.signal-desktop;

  firefox-addons = super.firefox-addons // { 
    polkadot-js = super.callPackage ./polkadot-js-extension.nix {}; 
  };
}


