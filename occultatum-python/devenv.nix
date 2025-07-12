{ pkgs, lib, config, inputs, ... }:

{
  languages.python = {
    enable = true;
    uv = {
      enable = true;
      sync.enable = true;
    };
    version = "3.11.0";
  };

  enterShell = ''
    source .venv/bin/activate
    export PYTHONPATH="$(echo $PYTHONPATH):$(pwd)/bases:$(pwd)/components:$(pwd)"
    '';

  scripts.poly.exec = ''
      uv run poly "$@"
    '';
}
