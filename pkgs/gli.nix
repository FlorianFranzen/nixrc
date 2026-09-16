{ lib, stdenv, fetchFromGitHub, cmake, glm }:

stdenv.mkDerivation (finalAttrs: {
  pname = "gli";
  version = "0.8.3-unstable-2021-05-15";

  # gli master (0.8.3, 2026) does not compile against glm 1.x: its
  # convert_func.hpp calls make_vec4 in ways that are ambiguous against glm's
  # current overload set. This is the revision vcpkg pins, and therefore the one
  # cnc-generals-zerohour is actually built and tested against upstream.
  src = fetchFromGitHub {
    owner = "g-truc";
    repo = "gli";
    rev = "779b99ac6656e4d30c3b24e96e0136a59649a869";
    hash = "sha256-mL55jF93WSRCoOrSZZzXscMm2RsI0a550IuZJ7j8Q6s=";
  };

  nativeBuildInputs = [ cmake ];

  # gli is header-only, but its headers include <glm/...>, so consumers need glm too.
  propagatedBuildInputs = [ glm ];

  # GLI_TEST_ENABLE does not actually guard the test subdirectory, and the tests
  # need the vendored external/glm submodule that is absent from the tarball.
  # Same fix vcpkg applies in ports/gli/disable-test.patch.
  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "add_subdirectory(test)" "#add_subdirectory(test)"

    # gli/type.hpp pulls all of glm into namespace gli and then defines its own
    # make_vec4 overloads, so an unqualified call matches both gli's and glm's.
    # GCC 15 rejects that as ambiguous where older compilers let it through.
    # Both definitions are identical ((x, 0, 0, 1)), so qualifying the call
    # changes nothing but which declaration is picked.
    substituteInPlace gli/core/convert_func.hpp \
      --replace-fail "make_vec4<retType, P>(" "gli::make_vec4<retType, P>("
  '';

  cmakeFlags = [
    # This revision predates CMake 3.5, support for which modern CMake dropped.
    (lib.cmakeFeature "CMAKE_POLICY_VERSION_MINIMUM" "3.5")
    # gli builds its package config path as ${CMAKE_INSTALL_LIBDIR}/cmake/gli and
    # then installs it relative to the build dir, which breaks on the absolute
    # libdir nixpkgs passes. Keep it relative so the two agree.
    (lib.cmakeFeature "CMAKE_INSTALL_LIBDIR" "lib")
  ];

  meta = {
    description = "Header-only C++ image library for graphics software";
    homepage = "https://github.com/g-truc/gli";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
})
