let
  buildImages = import ../.;
in buildImages [ ./postgresql.nix ]
