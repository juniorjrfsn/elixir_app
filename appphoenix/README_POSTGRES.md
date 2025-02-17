    GRANT USAGE ON SCHEMA public TO postgres;  
    GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO postgres;  
    ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL PRIVILEGES ON TABLES TO postgres;

    ### DROP DATABASE ###
    DROP DATABASE IF EXISTS appphoenix_dev;
    DROP DATABASE IF EXISTS appphoenix_prod;

    ### DROP SCHEMA ###
    DROP SCHEMA IF EXISTS appphoenix_dev;
    DROP SCHEMA IF EXISTS appphoenix_prod;

    ### CREATE SCHEMA ###
    CREATE SCHEMA  appphoenix_dev;
    CREATE SCHEMA  appphoenix_prod;

    ### CREATE DATABASE ###
    CREATE DATABASE appphoenix_dev;
    CREATE DATABASE appphoenix_prod;

    ### GRANT ###
    GRANT ALL PRIVILEGES ON DATABASE appphoenix_dev TO postgres;
    GRANT CONNECT ON DATABASE appphoenix_dev TO postgres;
    GRANT ALL PRIVILEGES ON DATABASE appphoenix_prod TO postgres;
    GRANT CONNECT ON DATABASE appphoenix_prod TO postgres;

    GRANT ALL PRIVILEGES ON SCHEMA appphoenix_dev TO postgres;
    GRANT USAGE ON SCHEMA appphoenix_dev TO postgres;
    ALTER DEFAULT PRIVILEGES IN SCHEMA appphoenix_dev GRANT ALL PRIVILEGES ON TABLES TO postgres;
    GRANT ALL PRIVILEGES ON SCHEMA appphoenix_prod TO postgres;
    GRANT USAGE ON SCHEMA appphoenix_prod TO postgres;
    ALTER DEFAULT PRIVILEGES IN SCHEMA appphoenix_prod GRANT ALL PRIVILEGES ON TABLES TO postgres;

    GRANT ALL PRIVILEGES ON DATABASE appphoenix_dev TO appphoenix_dev;
    GRANT CONNECT ON DATABASE appphoenix_dev TO appphoenix_dev;
    GRANT ALL PRIVILEGES ON DATABASE appphoenix_prod TO appphoenix_dev;
 
    GRANT ALL PRIVILEGES ON SCHEMA appphoenix_dev TO appphoenix_dev;
    GRANT USAGE ON SCHEMA appphoenix_dev TO appphoenix_dev;
    ALTER DEFAULT PRIVILEGES IN SCHEMA appphoenix_dev GRANT ALL PRIVILEGES ON TABLES TO appphoenix_dev;
    GRANT ALL PRIVILEGES ON SCHEMA appphoenix_prod TO appphoenix_dev;
    GRANT USAGE ON SCHEMA appphoenix_prod TO appphoenix_dev;
    ALTER DEFAULT PRIVILEGES IN SCHEMA appphoenix_prod GRANT ALL PRIVILEGES ON TABLES TO appphoenix_dev;

    -- Cria uma role chamada "appphoenix_dev" com login e senha
    CREATE ROLE appphoenix_dev LOGIN PASSWORD 'appphoenix_dev';
    CREATE ROLE appphoenix_prod LOGIN PASSWORD 'appphoenix_prod';

    -- Concede permissões de conexão ao banco de dados
    GRANT CONNECT ON DATABASE appphoenix_dev TO appphoenix_dev;
    GRANT CONNECT ON DATABASE appphoenix_prod TO appphoenix_prod;

    -- Concede permissões de uso no schema
    GRANT USAGE ON SCHEMA appphoenix_dev TO appphoenix_dev;
    GRANT USAGE ON SCHEMA appphoenix_prod TO appphoenix_prod;
 
    -- Concede permissões de leitura em todas as tabelas do schema
    GRANT SELECT ON ALL TABLES IN SCHEMA appphoenix_dev TO appphoenix_dev;
    GRANT SELECT ON ALL TABLES IN SCHEMA appphoenix_prod TO appphoenix_prod;

    GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA appphoenix_dev TO appphoenix_dev;
    GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA appphoenix_prod TO appphoenix_prod;

    GRANT ALL PRIVILEGES ON SCHEMA  appphoenix_dev TO appphoenix_dev;
    GRANT ALL PRIVILEGES ON SCHEMA  appphoenix_prod TO appphoenix_prod;
    
    GRANT USAGE ON SCHEMA appphoenix_dev TO appphoenix_dev;  
    GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA appphoenix_dev TO appphoenix_dev;  
    ALTER DEFAULT PRIVILEGES IN SCHEMA appphoenix_dev GRANT ALL PRIVILEGES ON TABLES TO appphoenix_dev;

    -- Configura permissões para futuras tabelas
    ALTER DEFAULT PRIVILEGES IN SCHEMA appphoenix_dev GRANT SELECT ON TABLES TO appphoenix_dev;
    ALTER DEFAULT PRIVILEGES IN SCHEMA appphoenix_prod GRANT SELECT ON TABLES TO appphoenix_prod;


    GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA appphoenix_dev TO postgres;
    GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA appphoenix_prod TO postgres;

    GRANT ALL PRIVILEGES ON SCHEMA  appphoenix_dev TO postgres;
    GRANT ALL PRIVILEGES ON SCHEMA  appphoenix_prod TO postgres;

    GRANT USAGE ON SCHEMA appphoenix_dev TO postgres;  
    GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA appphoenix_dev TO postgres;  
    ALTER DEFAULT PRIVILEGES IN SCHEMA appphoenix_dev GRANT ALL PRIVILEGES ON TABLES TO postgres;

    GRANT USAGE ON SCHEMA appphoenix_prod TO postgres;  
    GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA appphoenix_prod TO postgres;  
    ALTER DEFAULT PRIVILEGES IN SCHEMA appphoenix_prod GRANT ALL PRIVILEGES ON TABLES TO postgres;

    CREATE DATABASE
    postgres=# create database appphoenix_dev;
    postgres=# grant all privileges on database appphoenix_dev to postgres;
    GRANT
    postgres=# create database appphoenix_prod;
    CREATE DATABASE
    postgres=# grant all privileges on database appphoenix_prod to postgres;
    GRANT 

  postgres=#


postgres
  https://www.pgadmin.org/download/pgadmin-4-apt/
  OU
  DBEAVER localhost 5432 appphoenix_dev postgres 'postgres'