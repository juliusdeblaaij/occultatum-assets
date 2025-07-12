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

  scripts.poly.exec = ''
      uv run poly "$@"
    '';
}
