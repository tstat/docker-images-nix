{ pkgs, config, lib, ... }:

{
  imports = [ ../postgresql ];
  config = {
    postgresql = {
      dev = {
        enable = true;
        package = pkgs.postgresql_11;
        enableTCPIP = true;

        authentication = ''
          local all all           trust
          host  all all 0.0.0.0/0 trust
        '';

        extraConfig = ''
          log_statement = 'all'
          log_duration = true
          session_preload_libraries = 'auto_explain'
          auto_explain.log_min_duration = 0
          auto_explain.log_analyze = true
        '';
      };
    };
  };
}
