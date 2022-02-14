self: super:

let
  # Updated wayland protocols
  wayland-protocols = super.wayland-protocols.overrideAttrs (old: rec {
    name = "wayland-protocols-${version}";
    version = "d324986823519c15b2162fc3e0a720f349e43b0c";

    src = super.fetchFromGitLab {
      domain = "gitlab.freedesktop.org";
      owner = "wayland";
      repo = "wayland-protocols";
      rev = version;
      sha256 = "2RNhAnEQ3lirNGA9BvhqU18em5pujEyTNDWApZCAG8w=";
    };
  });

  # Updated wlroots
  wlroots = (super.wlroots.overrideAttrs (old: rec {
      version = "252b2348";
      name = "${old.pname}-${version}";

      src = super.fetchFromGitLab {
        domain = "gitlab.freedesktop.org";
        owner = "wlroots";
        repo = "wlroots";
        rev = version;
        sha256 = "RQ/QJeD+b3PdcxJTEkzBq7OXsMl+HD5tIDxLyYbiWL8="; 
      };
  })).override { inherit wayland-protocols; };
in {
  # Sway, but with gestures
  sway-unwrapped = (super.sway-unwrapped.overrideAttrs (old: rec {
    version = "1.8.0-gestures";
    name = "${old.pname}-${version}";

    src = super.fetchFromGitHub {
      owner = "FlorianFranzen";
      repo = "sway";
      rev = "pointer-gestures";
      sha256 = "RRVJOegki1pu4tUx5jwVAB/nF0hK8B6NX8CsZRKF2w8=";
    };
  })).override { inherit wlroots; };

  sway = super.sway.override {
    inherit (self) sway-unwrapped;
  };

  glpaper = super.glpaper.overrideAttrs (old: {
    patches = [
      (super.fetchpatch {
        url = "https://lists.sr.ht/~scoopta/glpaper/%3C6eb52d49af8270c3df0d.1644834735%40localhost%3E/raw";
        sha256 = "C9mogxU/9mPIqo+sbkiYRbBCg6yOc8srS/CvzyMaJMQ=";
      })
    ];
  });
}
