{ pkgs, config, lib, ... }:

with lib; with pkgs;
let
  mkPostgresImage = tag: cfg:
    let
      configFile = writeText "postgresql.conf" ''
        hba_file = '${writeText "pg_hba.conf" cfg.authentication}'
        ident_file = '${writeText "pg_ident.conf" cfg.identMap}'
        log_destination = 'stderr'
        listen_addresses = '${if cfg.enableTCPIP then "*" else "127.0.0.1"}'
        port = ${toString cfg.port}
        unix_socket_directories '/var/run/postgresql'
        ${cfg.extraConfig}
      '';
      entrypoint = writeScript "entrypoint.sh" ''
      #!${stdenv.shell}
        set -e
        exec "$@"
      '';
    in mkIf cfg.enable (with dockerTools; buildImage {
      name = "postgres";
      tag = tag;
      contents = [ cfg.package bash ];
      runAsRoot = ''
      #!${stdenv.shell}
      ${shadowSetup}
      echo 'hosts: files dns' > /etc/nsswitch.conf
      groupadd -r postgres
      useradd -r -g postgres -M postgres
      mkdir -p /var/run/postgresql
      chown -R postgres:postgres /var/run/postgresql
      chmod 2775 /var/run/postgresql
      mkdir -p ${cfg.dataDir}
      chown -R postgres:postgres ${cfg.dataDir}
      ${su}/bin/su postgres -c "${cfg.package}/bin/initdb -U postgres -D ${cfg.dataDir}"
      ln -sfn "${configFile}" "${cfg.dataDir}/postgresql.conf"
      '';
      config = {
      Cmd = [ "${su-exec}/bin/su-exec" "postgres" "/bin/postgres" ];
        WorkingDir = "/";
        Entrypoint = [ entrypoint ];
        Env = [
          "PGDATA=${cfg.dataDir}"
        ];
      };
    });
in
{
  options.postgresql = mkOption {
    type = types.attrsOf
            (types.submodule
             (import ./options.nix { inherit lib; }));
    };

  config.images.postgresql = mapAttrs mkPostgresImage config.postgresql;
}
