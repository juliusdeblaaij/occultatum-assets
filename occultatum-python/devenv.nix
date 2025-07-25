{ pkgs, lib, config, inputs, ... }:
let
  nativeBuildInputs = with pkgs.buildPackages; [
    ninja
    python311Packages.torch
  ];

  buildInputs = with pkgs; [
    stdenv.cc.cc
    libuv
    zlib
    expat
    libGL
    glib
    stdenv.cc.cc.lib
  ];
in
{
  packages = with pkgs; [
    cmake
    ninja
    clang
    xorg.libX11
  ] ++ nativeBuildInputs;

  env = {
    LD_LIBRARY_PATH = "${lib.makeLibraryPath buildInputs}";
    # Prevent Python packages from trying to download their own CMake
    CMAKE = "${pkgs.cmake}/bin/cmake";
    # Tell scikit-build-core to skip searching for CMake
    SKBUILD_CMAKE_EXECUTABLE = "${pkgs.cmake}/bin/cmake";
    # Prevent CUDA requirements for torchmcubes
    CMAKE_ARGS = "-DCMAKE_CUDA_COMPILER=IGNORE";
    USE_XPU=0;
    CMAKE_PREFIX_PATH="Torch";
  };
  
  languages.python = {
    enable = true;
    uv = {
      enable = true;
      sync.enable = true;
    };
    version = "3.11.0";
  };

  enterShell = ''
    source .devenv/state/venv/bin/activate
    export PYTHONPATH="$(echo $PYTHONPATH):$(pwd)/bases:$(pwd)/components:$(pwd)"
    '';

  scripts.poly.exec = ''
      uv run poly "$@"
    '';
}
