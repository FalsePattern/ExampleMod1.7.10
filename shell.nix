# 1.7.10 needs these dependencies to run
let
  nixpkgs = import <nixpkgs> {};
in
  with nixpkgs;
  stdenv.mkDerivation {
    name = "minecraft-1.7.10-dev";
    buildInputs = [
      # Java
      temurin-bin-8

      # LWJGL 2
      xorg.libX11
      xorg.libXext
      xorg.libXcursor
      xorg.libXrandr
      xorg.libXxf86vm
      libGL
    ];
    shellHook = ''
      export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${xorg.libX11}/lib
      export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${xorg.libXext}/lib
      export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${xorg.libXcursor}/lib
      export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${xorg.libXrandr}/lib
      export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${xorg.libXxf86vm}/lib
      export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${libGL}/lib
    '';
  }
