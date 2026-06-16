CREATE USER postgres_exporter WITH PASSWORD 'exporter_password';
ALTER USER postgres_exporter SET search_path TO pg_catalog;
GRANT pg_monitor TO postgres_exporter;