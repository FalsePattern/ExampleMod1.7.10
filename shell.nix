{ pkgs ? import <nixpkgs> { }, lib ? pkgs.lib }:
let
  openal64 = { pkgs, ...}:
  let
    stdenv = pkgs.stdenv;
    openal = pkgs.openal;
  in stdenv.mkDerivation rec {
    pname = "openal64";
    version = openal.version;
    dontUnpack = true;
    buildInputs = [ openal ];
    installPhase = ''
      runHook preInstall
      mkdir -p $out/lib
      ln -s ${openal}/lib/libopenal.so $out/lib/libopenal64.so
      runHook postInstall
    '';
  };
  runtimeLibs = with pkgs; (
    [
      temurin-bin-8
    ]
    ++ (with xorg; [
      libX11
      libXext
      libXcursor
      libXrandr
      libXxf86vm
      libXrender
      libXi
      libXtst
    ])
    ++ [
      # lwjgl
      libpulseaudio
      libGL
      openal
      (callPackage openal64 { inherit pkgs; })
      glfw
      stdenv.cc.cc.lib

      # oshi
      udev
    ]
  );
  runtimePrograms = with pkgs; [
    xorg.xrandr
    mesa-demos # need glxinfo
  ];
in
pkgs.mkShell rec {
  name = "minecraft-1.7.10-dev";
  buildInputs = runtimeLibs ++ runtimePrograms;
  shellHook = ''
    export LD_LIBRARY_PATH=/run/opengl-driver/lib:${lib.makeLibraryPath runtimeLibs}:$LD_LIBRARY_PATH
    export PATH=$PATH:${lib.makeBinPath runtimePrograms}
  '';
  XDG_DATA_DIRS = builtins.getEnv "XDG_DATA_DIRS";
  XDG_RUNTIME_DIR = builtins.getEnv "XDG_RUNTIME_DIR";
}
