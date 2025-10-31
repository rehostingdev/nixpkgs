{
  stdenv,
  newlib,
  texinfo,
  stdenvNoLibc,
  buildPackages,
}:

stdenvNoLibc.mkDerivation {
  name = "newlib";
  src = newlib.src;

  depsBuildBuild = [
    buildPackages.stdenv.cc
    texinfo # for makeinfo
  ];

  # newlib expects CC to build for build platform, not host platform
  preConfigure = ''
    export CC=cc
  '';

  configurePlatforms = [
    "build"
    "target"
  ];
  configureFlags = [
    "--host=${stdenv.buildPlatform.config}"

    "--disable-newlib-supplied-syscalls"
    "--disable-nls"
    "--enable-newlib-io-long-long"
    "--enable-newlib-register-fini"
    "--enable-newlib-retargetable-locking"
  ];

  dontDisableStatic = true;

  NIX_CFLAGS_COMPILE = "-I../../newlib/libc/machine/xtensa/include";

  passthru = {
    incdir = "/${stdenv.targetPlatform.config}/include";
    libdir = "/${stdenv.targetPlatform.config}/lib";
  };
}
