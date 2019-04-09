let
  pkgs = (import <nixpkgs> {}).fetchFromGitHub {
    owner = "NixOS";
    repo = "nixpkgs-channels";
    rev = "5d3fd3674a66c5b1ada63e2eace140519849c967";
    sha256 = "1yjn56jsczih4chjcll63a20v3nwv1jhl2rf6rk8d8cwvb10g0mk";
  };


in import pkgs {}
