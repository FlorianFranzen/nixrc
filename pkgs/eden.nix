{ lib
, stdenv
, fetchgit
, fetchurl
, nix-update-script
, wrapQtAppsHook
, autoconf
, boost183
, catch2_3
, cmake
, compat-list
, cpp-jwt
, cubeb
, enet
, ffmpeg_7-headless
, fmt_10
, gamemode
, glslang
, libopus
, libusb1
, libva
, lz4
, nlohmann_json
, nv-codec-headers-12
, nx_tzdb
, openssl
, pkg-config
, qtbase
, qtcharts
, qtmultimedia
, qttools
, qtwayland
, qtwebengine
, SDL2
, spirv-headers
, spirv-tools
, vulkan-headers
, vulkan-loader
, vulkan-memory-allocator
, vulkan-utility-libraries
, xbyak
, yasm
, zlib
, zstd
, quazip
, ...
}:

let
  # Unpack a fetchurl tarball into a plain directory suitable for *_CUSTOM_DIR.
  # SHA-512 hashes come directly from cpmfile.json (CPM verifies the same files).
  unpackSrc = { name, src, patches ? [], nativeBuildInputs ? [] }:
    stdenv.mkDerivation {
      inherit name src patches nativeBuildInputs;
      dontBuild = true;
      dontConfigure = true;
      installPhase = "cp -r . $out";
    };

  simpleini-src = unpackSrc {
    name = "simpleini-4.25-src";
    src = fetchurl {
      url = "https://github.com/brofield/simpleini/archive/refs/tags/v4.25.tar.gz";
      hash = "sha512-uTfBintid9d8p+v7IWr0mEgQ93r0wy0QG3aFNppL1ethQGIj+CaY4WfmMRpyjQdBWrWWOf3xnv9xrW3Cq/2piQ==";
    };
  };

  frozen-src = unpackSrc {
    name = "frozen-61dce5ae-src";
    src = fetchurl {
      url = "https://github.com/serge-sans-paille/frozen/archive/61dce5ae18.tar.gz";
      hash = "sha512-uN/nQcgrwXjfyXSdSrWhMM7nGNnue3HZtUfPX38jAn7QFSrSUAEqhUY5n8weEhh+/GjYnWcxJWxNLffQTu+NXA==";
    };
  };

  httplib-src = unpackSrc {
    name = "httplib-0.37.0-src";
    src = fetchurl {
      url = "https://github.com/yhirose/cpp-httplib/archive/refs/tags/v0.37.0.tar.gz";
      hash = "sha512-XvqBQKrf/hBdzzmTW3MkdulXVfbHRzraPQtk3yvALFV2M645SKJbReHPZ+iaP/Yyn7MDYuSsAzuaHR5FOqLt7Q==";
    };
  };

  # Eden-specific discord-rpc fork with status_display_type API (not in nixpkgs 3.4.0)
  discord-rpc-src = unpackSrc {
    name = "discord-rpc-0d8b2d6a37-src";
    src = fetchurl {
      url = "https://github.com/eden-emulator/discord-rpc/archive/0d8b2d6a37.tar.gz";
      hash = "sha512-ghPEPcsPfUefWGEJHREe0S+97B5i5tcp1lpLwYHYL0ijXV/TzVwpHyOTrHyWgeq8a3Zgl1X1U3YoTIqNZ+FI8w==";
    };
  };

  # Release artifact — hash comes from the upstream .sha512sum sidecar file
  sirit-src = unpackSrc {
    name = "sirit-1.0.4-src";
    nativeBuildInputs = [ zstd ];
    src = fetchurl {
      url = "https://github.com/eden-emulator/sirit/releases/download/v1.0.4/sirit-source-1.0.4.tar.zst";
      hash = "sha512-iViFeqlDJr7KClRyCAvSJiCDKyV+n4Oi90lHz4ymNp11pxDvr5Ev1EWgiASvZCfvZy7yLiB6ZG1IctPoA3BJOQ==";
    };
  };

  # Sources requiring upstream patches that CPM would normally apply in-tree
  unordered-dense-src = unpackSrc {
    name = "unordered-dense-7b55cab8-src";
    src = fetchurl {
      url = "https://github.com/martinus/unordered_dense/archive/7b55cab841.tar.gz";
      hash = "sha512-0hBvZkD2v7gXVeS4v7ZJguRuxKUHys2zj5QBIyEszzWiC0PHDG8B17+4wkbRoW94RdgFKXGUnOqd7xR14/oCyA==";
    };
  };

  mcl-src = unpackSrc {
    name = "mcl-7b08d834-src";
    src = fetchurl {
      url = "https://github.com/azahar-emu/mcl/archive/7b08d83418.tar.gz";
      hash = "sha512-nGumJMsi72IveARqgqu5m/UCYoS6F9+sr0ashCy9Ow9RX1ukWhWYx2cTGKeKLmSNtyzo0Q51N/NOOYAL3LV2lA==";
    };
  };

in stdenv.mkDerivation(finalAttrs: {
  pname = "eden";
  version = "0.2.0-rc2";

  src = fetchgit {
    url = "https://git.eden-emu.dev/eden-emu/eden";
    rev = "v${finalAttrs.version}";
    hash = "sha256-keLkB5qeQch+tM2J6zVh9oQGhP5TuxItqrZRN24apJw=";
  };

  nativeBuildInputs = [
    cmake
    glslang
    pkg-config
    qttools
    wrapQtAppsHook
  ];

  buildInputs = [
    # vulkan-headers must come first, so the older propagated versions
    # don't get picked up by accident
    vulkan-headers
    vulkan-utility-libraries

    boost183
    catch2_3
    cpp-jwt
    cubeb
    # intentionally omitted: discord-rpc - provided via CPM custom dir (eden fork) below
    # intentionally omitted: dynarmic - prefer vendored version for compatibility
    enet

    # ffmpeg deps (also includes vendored)
    # we do not use internal ffmpeg because cuda errors
    autoconf
    yasm
    libva  # for accelerated video decode on non-nvidia
    nv-codec-headers-12  # for accelerated video decode on nvidia
    ffmpeg_7-headless
    # end ffmpeg deps

    fmt_10
    # headers needed at compile time even though the lib is loaded dynamically at runtime
    gamemode
    # intentionally omitted: httplib - provided via CPM custom dir below
    libopus
    libusb1
    # intentionally omitted: LLVM - heavy, only used for stack traces in the debugger
    lz4
    nlohmann_json
    openssl
    qtbase
    qtcharts
    qtmultimedia
    qtwayland
    qtwebengine
    quazip
    # intentionally omitted: renderdoc - heavy, developer only
    SDL2
    spirv-headers
    spirv-tools
    vulkan-memory-allocator
    xbyak
    zlib
    zstd
  ];

  # This changes `ir/opt` to `ir/var/empty` in `externals/dynarmic/src/dynarmic/CMakeLists.txt`
  # making the build fail, as that path does not exist
  dontFixCmake = true;

  cmakeFlags = [
    # actually has a noticeable performance impact
    "-DENABLE_LTO=ON"

    # disable cmake package manager downloads; force system packages for all CPM deps
    "-DYUZU_USE_CPM=OFF"
    "-DCPMUTIL_FORCE_SYSTEM=ON"

    # build with qt6
    "-DENABLE_QT6=ON"
    "-DENABLE_QT_TRANSLATION=ON"

    # use system libraries; "external" = vendored in externals/, so OFF = use system
    "-DYUZU_USE_EXTERNAL_SDL2=OFF"
    "-DYUZU_USE_EXTERNAL_VULKAN_HEADERS=OFF"
    "-DYUZU_USE_EXTERNAL_VULKAN_UTILITY_LIBRARIES=OFF"

    # explicitly disable all bundled (download) options
    "-DYUZU_USE_BUNDLED_QT=OFF"
    "-DYUZU_USE_BUNDLED_FFMPEG=OFF"
    "-DYUZU_USE_BUNDLED_SDL2=OFF"
    "-DYUZU_USE_BUNDLED_OPENSSL=OFF"
    "-DYUZU_USE_BUNDLED_SIRIT=OFF"

    # don't check for missing submodules
    "-DYUZU_CHECK_SUBMODULES=OFF"

    # enable some optional features
    "-DYUZU_USE_QT_WEB_ENGINE=ON"
    "-DYUZU_USE_QT_MULTIMEDIA=ON"
    "-DUSE_DISCORD_PRESENCE=ON"

    # We dont want to bother upstream with potentially outdated compat reports
    "-DYUZU_ENABLE_COMPATIBILITY_REPORTING=OFF"
    "-DENABLE_COMPATIBILITY_LIST_DOWNLOAD=OFF" # We provide this deterministically

    # Fix cmake compatibility error
    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"

    # provide pre-downloaded timezone database; DOWNLOAD_TIME_ZONE_DATA=ON (default)
    # skips the build-from-source path; TZDB_PATH overrides the CPM download path
    "-DYUZU_TZDB_PATH=${nx_tzdb}"

    # pre-fetched sources for CPM packages not available in nixpkgs
    # (patch-free sources: CPM has no patches for these)
    "-DDiscordRPC_CUSTOM_DIR=${discord-rpc-src}"
    "-DSimpleIni_CUSTOM_DIR=${simpleini-src}"
    "-Dfrozen_CUSTOM_DIR=${frozen-src}"
    "-Dsirit_CUSTOM_DIR=${sirit-src}"
    # httplib, unordered_dense, mcl have CPM-managed patches; set via preConfigure
    # after copying to a writable staging area so patch(1) can write temp files
  ];

  # Does some handrolled SIMD
  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isx86_64 "-msse4.1";

  # Fixes vulkan detection.
  # FIXME: patchelf --add-rpath corrupts the binary for some reason, investigate
  qtWrapperArgs = [
    "--prefix LD_LIBRARY_PATH : ${vulkan-loader}/lib"
  ];

  preConfigure = ''
    # see https://github.com/NixOS/nixpkgs/issues/114044, setting this through cmakeFlags does not work.
    cmakeFlagsArray+=(
      "-DTITLE_BAR_FORMAT_IDLE=${finalAttrs.pname} | ${finalAttrs.version} (nixpkgs) {}"
      "-DTITLE_BAR_FORMAT_RUNNING=${finalAttrs.pname} | ${finalAttrs.version} (nixpkgs) | {}"
    )

    # CPM applies cpmfile.json patches to _CUSTOM_DIR sources in-place via
    # FetchContent PATCH_COMMAND.  Nix store paths are read-only, so copy the
    # affected sources to a writable staging area and point CPM there instead.
    mkdir -p "$NIX_BUILD_TOP/cpm-sources"
    cp -r ${httplib-src}        "$NIX_BUILD_TOP/cpm-sources/httplib"
    cp -r ${unordered-dense-src} "$NIX_BUILD_TOP/cpm-sources/unordered-dense"
    cp -r ${mcl-src}            "$NIX_BUILD_TOP/cpm-sources/mcl"
    chmod -R u+w "$NIX_BUILD_TOP/cpm-sources"
    cmakeFlagsArray+=(
      "-Dhttplib_CUSTOM_DIR=$NIX_BUILD_TOP/cpm-sources/httplib"
      "-Dunordered_dense_CUSTOM_DIR=$NIX_BUILD_TOP/cpm-sources/unordered-dense"
      "-Dmcl_CUSTOM_DIR=$NIX_BUILD_TOP/cpm-sources/mcl"
    )
  '';

  postConfigure = ''
    ln -sf ${compat-list} ./dist/compatibility_list/compatibility_list.json
  '';

  postInstall = "
    install -Dm444 $src/dist/72-yuzu-input.rules $out/lib/udev/rules.d/72-eden-input.rules
  ";

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex" "v(.*)" ];
  };

  meta = with lib; {
    homepage = "https://eden-emu.dev";
    changelog = "https://git.eden-emu.dev/eden-emu/eden/releases";
    description = "An experimental Nintendo Switch emulator forked from yuzu";
    longDescription = ''
      Eden is an experimental Nintendo Switch emulator written in C++,
      forked from yuzu. It aims to provide accurate emulation with
      active development and community support.
    '';
    mainProgram = "eden";
    platforms = [ "aarch64-linux" "x86_64-linux" ];
    license = with licenses; [
      gpl3Plus
      # Icons
      asl20 mit cc0
    ];
  };
})
