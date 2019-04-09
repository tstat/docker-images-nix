let
  pkgs = import ./world.nix;
in xs:
  let
    result = pkgs.lib.evalModules {
      modules = [
        { imports = ([ ./base.nix ] ++ xs);
        }
      ];
    };
  in result.config.images
