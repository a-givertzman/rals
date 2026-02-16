do $$
begin
    if not exists (SELECT 1 FROM pg_user WHERE usename = 'cma') THEN
        CREATE USER cma WITH PASSWORD '00d0' CREATEDB CREATEROLE;
    end if;
end
$$;
