{ pkgs ? import <nixpkgs> { }, lib ? pkgs.lib }:
pkgs.mkShell rec {
  name = "minecraft-1.7.10-dev";
  buildInputs = with pkgs; (
    [
      temurin-bin-8
    ]
    ++ (with xorg; [
      libX11
      libXext
      libXcursor
      libXrandr
      libXxf86vm
    ])
    ++ [
      libpulseaudio
      libGL
      glfw
      openal
      stdenv.cc.cc.lib
    ]
  );
  LD_LIBRARY_PATH = "${lib.makeLibraryPath buildInputs}";
  XDG_DATA_DIRS = builtins.getEnv "XDG_DATA_DIRS";
  XDG_RUNTIME_DIR = builtins.getEnv "XDG_RUNTIME_DIR";
}
