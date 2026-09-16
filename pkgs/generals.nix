{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  cmake,
  ninja,
  pkg-config,
  makeWrapper,
  autoPatchelfHook,
  nasm,
  ffmpeg,
  fontconfig,
  freetype,
  gli,
  glm,
  libGL,
  openal,
  sdl3,
  sdl3-image,
  vulkan-loader,
  zlib,
}:

let
  # The build pulls these in with FetchContent at configure time, which cannot
  # reach the network inside the Nix sandbox. Each is pinned to the exact rev
  # named in CMakeLists.txt and handed to CMake via FETCHCONTENT_SOURCE_DIR_*.
  gamespy = fetchFromGitHub {
    owner = "feliwir";
    repo = "GamespySDK";
    rev = "582c79105aa851c5aa847f638722f61195b79c9b";
    hash = "sha256-9F2OqXDn9nPh3agQTDav8bdpGRj5va1rCSlinoh+rXs=";
  };

  miles = fetchFromGitHub {
    owner = "TheSuperHackers";
    repo = "miles-sdk-stub";
    rev = "0fef646a85c822475d55f19e3ca185263fb4a967";
    hash = "sha256-+kLLJ8yAg4KduboUkfa5kZ0afJOF5p7r53YKBGX8Mgs=";
  };

  liblzhl = fetchFromGitHub {
    owner = "feliwir";
    repo = "liblzhl";
    rev = "fd7c70c4bb96e7a4a682f574e788c499f00a0b8d";
    hash = "sha256-UlQSSDujReebKcWkeiZcW9GuVt9Shk38u73WqwayZuQ=";
  };

  # Prebuilt dxvk-native provides the libdxvk_d3d8/d3d9 shims the D3D8 renderer
  # is linked against. Built for steamrt-sniper, so autoPatchelfHook fixes it up.
  dxvk-native = fetchurl {
    url = "https://github.com/doitsujin/dxvk/releases/download/v2.6/dxvk-native-2.6-steamrt-sniper.tar.gz";
    hash = "sha256-nBorLIplZecb3l8YtsGn4KxNYhAjvTgASkIaX+9CEqw=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "cnc-generals-zerohour";
  version = "0-unstable-2026-08-18";

  src = fetchFromGitHub {
    owner = "Fighter19";
    repo = "CnC_Generals_Zero_Hour";
    rev = "088f3e610bc46cca809689e31ea87b5585a1e382";
    hash = "sha256-XcKHrzQn4bhqQ8v+aBW3qS5sx3Y01laCb8s9yk3Q+2Y=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    cmake
    makeWrapper
    nasm
    ninja
    pkg-config
  ];

  buildInputs = [
    ffmpeg
    fontconfig
    freetype
    gli
    glm
    libGL
    openal
    sdl3
    sdl3-image
    vulkan-loader
    zlib
  ];

  # Two things upstream only gets away with because vcpkg supplies them:
  #   - a lowercase freetypeConfig.cmake (nixpkgs' meson-built freetype ships
  #     pkg-config only, and CMake's bundled module is named FindFreetype);
  #   - a FindFFMPEG.cmake module, which CMake has no builtin for.
  # Retarget the first at the builtin module, and provide the second below.
  postPatch = ''
    substituteInPlace GeneralsMD/Code/Libraries/Source/WWVegas/WW3D2/CMakeLists.txt \
      --replace-fail "find_package(freetype REQUIRED)" "find_package(Freetype REQUIRED)"

    mkdir -p cmake-nix
    cat > cmake-nix/FindFFMPEG.cmake <<'EOF'
    find_package(PkgConfig REQUIRED)
    pkg_check_modules(FFMPEG REQUIRED IMPORTED_TARGET
      libavcodec libavformat libavutil libswscale libswresample)
    set(FFMPEG_LIBRARIES PkgConfig::FFMPEG)
    EOF
  '';

  # FetchContent wants to touch its source trees, and the store is read-only.
  # The dxvk release tarball has a single usr/ prefix that FetchContent would
  # normally strip, so strip it here to keep ${dxvk_SOURCE_DIR}/{include,lib}
  # resolving the way CMakeLists.txt expects.
  preConfigure = ''
    mkdir -p "$NIX_BUILD_TOP/deps"
    cp -r --no-preserve=mode ${gamespy} "$NIX_BUILD_TOP/deps/gamespy"
    cp -r --no-preserve=mode ${miles} "$NIX_BUILD_TOP/deps/miles"
    cp -r --no-preserve=mode ${liblzhl} "$NIX_BUILD_TOP/deps/liblzhl"

    mkdir -p "$NIX_BUILD_TOP/deps/dxvk"
    tar -xf ${dxvk-native} -C "$NIX_BUILD_TOP/deps/dxvk" --strip-components=1
    chmod -R u+w "$NIX_BUILD_TOP/deps/dxvk"

    cmakeFlagsArray+=(
      "-DCMAKE_MODULE_PATH=$PWD/cmake-nix"
      "-DFETCHCONTENT_SOURCE_DIR_GAMESPY=$NIX_BUILD_TOP/deps/gamespy"
      "-DFETCHCONTENT_SOURCE_DIR_MILES=$NIX_BUILD_TOP/deps/miles"
      "-DFETCHCONTENT_SOURCE_DIR_LIBLZHL=$NIX_BUILD_TOP/deps/liblzhl"
      "-DFETCHCONTENT_SOURCE_DIR_DXVK=$NIX_BUILD_TOP/deps/dxvk"
    )
  '';

  cmakeFlags = [
    # Mirrors the upstream linux64-deploy preset, minus the vcpkg toolchain.
    (lib.cmakeBool "SAGE_BUILD_ZEROHOUR" true)
    (lib.cmakeBool "SAGE_BUILD_GENERALS" false)
    (lib.cmakeBool "SAGE_BUILD_TESTS" false)
    (lib.cmakeBool "SAGE_USE_SDL3" true)
    (lib.cmakeBool "SAGE_USE_GLM" true)
    (lib.cmakeBool "SAGE_USE_FFMPEG" true)
    (lib.cmakeBool "SAGE_USE_OPENAL" true)

    # Never reach for the network during configure; the FETCHCONTENT_SOURCE_DIR_*
    # pointers are appended from preConfigure, where $NIX_BUILD_TOP is known.
    (lib.cmakeBool "FETCHCONTENT_FULLY_DISCONNECTED" true)
  ];

  # The engine resolves its data files relative to the working directory, so the
  # wrapper has to cd into the user's own copy of the game before exec'ing RTS.
  postInstall = ''
    # CMake installs the executable straight into the prefix root.
    mkdir -p "$out/libexec" "$out/bin"
    mv "$out/RTS" "$out/libexec/RTS"

    # install(RUNTIME_DEPENDENCIES) copies the whole resolved closure — ~230
    # libraries — out of the store and into $out/lib. Only the dxvk shims and
    # the Miles stub are actually ours to ship; drop the rest and let
    # autoPatchelfHook link against the real nixpkgs libraries instead of stale
    # copies. Anything wrongly pruned here fails the build loudly in fixup
    # rather than silently, so the allowlist is safe to extend as upstream adds
    # bundled libraries.
    find "$out/lib" -mindepth 1 -maxdepth 1 \
      ! -name 'libdxvk_*' -exec rm -rf {} +

    # RTS links against the Miles Sound System stub, but install(RUNTIME_DEPENDENCIES)
    # only resolves libraries outside the build tree, so this one is built and
    # then never installed. Copy it out of the build directory by hand.
    cp -P _deps/miles-build/libmss32.so* "$out/lib/"

    makeWrapper "$out/libexec/RTS" "$out/bin/generals-zh" \
      --prefix LD_LIBRARY_PATH : "$out/lib" \
      --run '
        if [ -z "''${GENERALS_ZH_DATA:-}" ]; then
          for candidate in \
            "$HOME/.steam/steam/steamapps/common/Command & Conquer Generals - Zero Hour" \
            "$HOME/.local/share/Steam/steamapps/common/Command & Conquer Generals - Zero Hour" \
            "$HOME/.steam/root/steamapps/common/Command & Conquer Generals - Zero Hour" \
            "$HOME/Games/command-and-conquer-the-ultimate-collection/drive_c/Program Files (x86)/EA Games/Command & Conquer Generals Zero Hour"; do
            if [ -d "$candidate" ]; then
              GENERALS_ZH_DATA="$candidate"
              break
            fi
          done
        fi

        if [ -z "''${GENERALS_ZH_DATA:-}" ]; then
          echo "generals-zh: could not locate the Zero Hour game data." >&2
          echo "This package ships only the open-sourced engine; the game data" >&2
          echo "(*.big) must come from your own copy of the game." >&2
          echo "Set GENERALS_ZH_DATA to the directory containing them." >&2
          exit 1
        fi

        cd "$GENERALS_ZH_DATA" || exit 1
      '
  '';

  meta = {
    description = "Command & Conquer: Generals - Zero Hour, Linux-focused fork of the EA source release";
    longDescription = ''
      Builds the open-sourced SAGE engine only. Running the game additionally
      requires the original game data from a CD, Steam or EA App installation;
      point GENERALS_ZH_DATA at the directory holding it, or let the wrapper
      auto-detect a Steam install. The engine loads every *.big archive it finds
      there, so the directory contents matter rather than any fixed file list.

      Setting CNC_GENERALS_INSTALLPATH additionally loads the base Generals
      assets; on Linux the engine reads that environment variable in place of
      the Windows registry key it uses natively.

      Known gaps in this fork: Generals base game (Zero Hour only), music tracks
      and longer voice lines, and multiplayer.
    '';
    homepage = "https://github.com/Fighter19/CnC_Generals_Zero_Hour";
    license = lib.licenses.gpl3Only;
    mainProgram = "generals-zh";
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
  };
})
