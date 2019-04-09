{ lib }:

with lib;
{
  options = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to build PostgreSQL.
      '';
    };

    package = mkOption {
      type = types.package;
      description = ''
        PostgreSQL package to use.
      '';
    };

    port = mkOption {
      type = types.int;
      default = 5432;
      description = ''
        The port on which PostgreSQL listens.
      '';
    };

    dataDir = mkOption {
      type = types.path;
      default = "/var/lib/postgresql";
      example = "/var/lib/postgresql/9.6";
      description = ''
        Data directory for PostgreSQL.
      '';
    };

    authentication = mkOption {
      type = types.lines;
      default = "";
      description = ''
        Defines how users authenticate themselves to the server. By
        default, "trust" access to local users will always be granted
        along with any other custom options. If you do not want this,
        set this option using "lib.mkForce" to override this
        behaviour.
      '';
    };

    identMap = mkOption {
      type = types.lines;
      default = "";
      description = ''
        Defines the mapping from system users to database users.
      '';
    };

    initialScript = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = ''
        A file containing SQL statements to execute on first startup.
      '';
    };

    enableTCPIP = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether PostgreSQL should listen on all network interfaces.
        If disabled, the database can only be accessed via its Unix
        domain socket or via TCP connections to localhost.
      '';
    };

    extraPlugins = mkOption {
      type = types.listOf types.path;
      default = [];
      example = literalExample "[ (pkgs.postgis.override { postgresql = pkgs.postgresql_9_4; }) ]";
      description = ''
        When this list contains elements a new store path is created.
        PostgreSQL and the elements are symlinked into it. Then pg_config,
        postgres and pg_ctl are copied to make them use the new
        $out/lib directory as pkglibdir. This makes it possible to use postgis
        without patching the .sql files which reference $libdir/postgis-1.5.
      '';
      # Note: the duplication of executables is about 4MB size.
      # So a nicer solution was patching postgresql to allow setting the
      # libdir explicitely.
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = "Additional text to be appended to <filename>postgresql.conf</filename>.";
    };

    recoveryConfig = mkOption {
      type = types.nullOr types.lines;
      default = null;
      description = ''
        Contents of the <filename>recovery.conf</filename> file.
      '';
    };

    superUser = mkOption {
      type = types.str;
      default= "postgres";
      internal = true;
      description = ''
        NixOS traditionally used 'root' as superuser, most other distros use 'postgres'.
        From 17.09 we also try to follow this standard. Internal since changing this value
        would lead to breakage while setting up databases.
      '';
    };
  };
}
