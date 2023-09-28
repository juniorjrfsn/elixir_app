# Appphoenix

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
# Appphoenix

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix


# Create PhoenixFramework app

## INSTALL
POSTGRES
ERLANG
  apt install esl-erlang
ELIXIR

============= INSTALAÇÃO do phoenix ====================
mix archive.uninstall archive.ez --forceY

mix local.rebar --force
mix local.hex --force

mix archive.install hex ex_doc
mix local.hex
mix archive.install github hexpm/hex branch latest


--------------------------------------------------------------------------------
mix archive.install hex phx_new
===================================================

mix phx.new appphoenix
mix deps.get
cd appphoenix


We are almost there! The following steps are missing:

    $ cd appphoenix

Then configure your database in config/dev.exs and run:
   https://www.postgresql.org/docs/8.0/sql-createuser.html
   sudo -u postgres psql


  sudo -u postgres psql
  postgres=# ALTER USER postgres WITH PASSWORD 'postgres';
  ALTER ROLE
  postgres=# create database appphoenix_dev;
  CREATE DATABASE
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

config/dev.exs -- configure manualmente

    $ mix ecto.create

Start your Phoenix app with:

    $ mix phx.server

You can also run your app inside IEx (Interactive Elixir) as:

    $ iex -S mix phx.server

    https://hexdocs.pm/phoenix/json_and_apis.html
    mix phx.gen.json Postsservice Postservice posts title:string body:text
    https://www.wbotelhos.com/crud-in-5-minutes-with-phoenix-and-elixir/
    https://hexdocs.pm/phoenix/Mix.Tasks.Phx.Gen.Html.html
    mix phx.gen.html Posts  Post  posts title:string body:text

    https://hexdocs.pm/phoenix/json_and_apis.html
    mix phx.gen.json Pessoas Pessoa persons name:string description:text
          Add the resource to your :api scope in lib/appphoenix_web/router.ex:

          resources "/persons", PessoaController, except: [:new, :edit]


      Remember to update your repository by running migrations:

          $ mix ecto.migrate

    https://www.wbotelhos.com/crud-in-5-minutes-with-phoenix-and-elixir/
    https://hexdocs.pm/phoenix/Mix.Tasks.Phx.Gen.Html.html
    mix phx.gen.html Persons Person persons name:string description:text

    https://www.audreyhal.com/blog/getting-started-with-phoenix-and-elixir-setup-a-crud-app-in-minutes
    https://hexdocs.pm/phoenix/Mix.Tasks.Phx.Gen.Html.html
    mix phx.gen.html Functions Task tasks title:string description:string

    # geração de controllers sem conexão com banco de dados
    mix phx.gen.html Calculos  Calculo  calculos --no-schema --no-context
    # mas prefiro gerar completo
    mix phx.gen.html Calculos  Calculo  calculos campo1:float campo2:float total:float

    # router.ex
      "
    scope "/", appphoenixWeb do
      pipe_through :browser

      get "/", PageController, :home

      resources "/persons", PersonController
      resources "/tasks", TaskController
      resources "/post_web", TaskController
      resources "/calculos", CalculoController

    end

    scope "/api", appphoenixWeb do
      pipe_through :api
      resources "/posts", PostController, except: [:new, :edit]
      resources "/persons", PessoaController, except: [:new, :edit]
    end
      "

    mix phx.routes

    ## mix ecto.migrate
    MIX_ENV=dev mix ecto.migrate

    $ PORT=4000 MIX_ENV=dev mix phx.server
  -- http://localhost:4000

      http://127.0.0.1:4000/persons
      http://127.0.0.1:4000/persons/1
      http://127.0.0.1:4000/api/persons
      http://127.0.0.1:4000/api/persons/1/


    # starting in server (Dev)
    $ PORT=4000 MIX_ENV=dev elixir --erl "-detached" -S mix phx.server

  ## produção
    $ mix phx.gen.secret
    $ REALLY_LONG_SECRET => PoWY5+8jE5Q3O8i5qf8KrMHOM9FiB3BT/NLrzWWseutEVLNpjhhF66tz7ZlnJ+AG
    ## $ export SECRET_KEY_BASE=REALLY_LONG_SECRET
    $ export SECRET_KEY_BASE=PoWY5+8jE5Q3O8i5qf8KrMHOM9FiB3BT/NLrzWWseutEVLNpjhhF66tz7ZlnJ+AG
    ## $ export DATABASE_URL=ecto://USER:PASS@HOST/database
    $ export DATABASE_URL=ecto://postgres:postgres@localhost/appphoenix_prod
    $ mix deps.get --only prod
    $ MIX_ENV=prod mix compile
    $ MIX_ENV=prod mix assets.deploy
    $ mix phx.gen.release
            Your application is ready to be deployed in a release!

            See https://hexdocs.pm/mix/Mix.Tasks.Release.html for more information about Elixir releases.

            Here are some useful release commands you can run in any release environment:

                # To build a release
                mix release

                # To start your system with the Phoenix server running
                _build/dev/rel/appphoenix/bin/server

                # To run migrations
                _build/dev/rel/appphoenix/bin/migrate

            Once the release is running you can connect to it remotely:

                _build/dev/rel/appphoenix/bin/appphoenix remote

            To list all commands:

                _build/dev/rel/appphoenix/bin/appphoenix

    $ MIX_ENV=prod mix release
          Release appphoenix-0.1.0 already exists. Overwrite? [Yn] Y
          * assembling appphoenix-0.1.0 on MIX_ENV=prod
          * using config/runtime.exs to configure the release at runtime
          * skipping elixir.bat for windows (bin/elixir.bat not found in the Elixir installation)
          * skipping iex.bat for windows (bin/iex.bat not found in the Elixir installation)

          Release created at _build/prod/rel/appphoenix

              # To start your system
              _build/prod/rel/appphoenix/bin/appphoenix start

          Once the release is running:

              # To connect to it remotely
              _build/prod/rel/appphoenix/bin/appphoenix remote

              # To stop it gracefully (you may also send SIGINT/SIGTERM)
              _build/prod/rel/appphoenix/bin/appphoenix stop

          To list all commands:

              _build/prod/rel/appphoenix/bin/appphoenix

    $ MIX_ENV=prod mix ecto.migrate
    #teste
    $ PORT=4001 MIX_ENV=prod mix phx.server

    # Initial setup
    mix deps.get --only prod
    MIX_ENV=prod mix compile

    # Compile assets
    MIX_ENV=prod mix assets.deploy

    # Custom tasks (like DB migrations)
    MIX_ENV=prod mix ecto.migrate

    # Finally run the server
    PORT=4001 MIX_ENV=prod mix phx.server
  -- http://localhost:4001


    # starting in server (Produção)
    $ PORT=4001 MIX_ENV=prod elixir --erl "-detached" -S mix phx.server

      http://127.0.0.1:4001/persons
      http://127.0.0.1:4001/persons/1
      http://127.0.0.1:4001/api/persons
      http://127.0.0.1:4001/api/persons/1/