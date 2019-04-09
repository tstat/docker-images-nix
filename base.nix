{ config, lib, ... }:

with lib;
let
  cfg = config.images.postgresql;
in
{
  options = {
    images = mkOption {
      type = with types; attrsOf (attrsOf package);
      default = {};
    };
  };
  config = {
    _module.args = {
      pkgs = import ./world.nix;
    };
  };
}
