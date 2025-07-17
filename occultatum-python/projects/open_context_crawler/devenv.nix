{ pkgs, lib, config, inputs, ... }:

let
  buildInputs = with pkgs; [
    stdenv.cc.cc
    libuv
    zlib
  ];
in 
{
  env = { LD_LIBRARY_PATH = "${with pkgs; lib.makeLibraryPath buildInputs}"; };

  languages.python = {
    enable = true;
    uv = {
      enable = true;
      sync.enable = true;
    };
  };

  process.managers.process-compose.settings = {
    processes = {
      pc_log = {
        command = "tail -f -n100 process-compose.log";
        working_dir = "./logs";
      };
    };
  };

    services.postgres = {
    enable = true;
    initialDatabases = [
      {
        name = "oc_crawler";
        schema = ./oc_crawler_db.sql;
      }
    ];
    settings = {
      listen_addresses = lib.mkForce "*";
      port = 5432;
    };
    initialScript = ''
      DO
      $do$
      BEGIN
        IF NOT EXISTS (
          SELECT FROM pg_catalog.pg_roles WHERE rolname = 'postgres'
        ) THEN
          CREATE ROLE postgres WITH LOGIN SUPERUSER PASSWORD 'postgres';
        ELSE
          ALTER ROLE postgres WITH SUPERUSER PASSWORD 'postgres';
        END IF;
        IF NOT EXISTS (
          SELECT FROM pg_catalog.pg_roles WHERE rolname = 'oc_crawler'
        ) THEN
          CREATE ROLE oc_crawler WITH LOGIN PASSWORD 'oc_crawler';
        END IF;
      END
      $do$;
    '';
  };

  processes = {
    postgrest-server.exec = "postgrest postgrest.conf";
    pgadmin4-web.exec = "pgadmin4";
    oc-crawler.exec = "cd oc_crawler && uv run scrapy crawl oc_objects -s USER_AGENT='oc crawler'";
  };

  scripts.scrapy.exec = ''
      uv run scrapy "$@"
    '';

  scripts.scrapy-shell.exec = ''
      uv run scrapy shell -s  USER_AGENT='oc crawler'"$@"
    '';
  
  enterShell = ''
    . .devenv/state/venv/bin/activate
    psql --version
  '';

  packages = [
    pkgs.postgrest
  ];
}
