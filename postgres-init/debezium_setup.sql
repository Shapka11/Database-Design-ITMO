CREATE USER dbz_user WITH REPLICATION PASSWORD 'dbz_secure_password';

GRANT USAGE ON SCHEMA public TO dbz_user;
GRANT SELECT ON public.house_point_logs TO dbz_user;

ALTER TABLE public.house_point_logs REPLICA IDENTITY DEFAULT;

CREATE PUBLICATION dbz_publication FOR TABLE public.house_point_logs;