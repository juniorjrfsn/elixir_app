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

mix phx.new appphoenix
cd appphoenix
mix deps.get


Then configure your database in config/dev.exs and run:
    $ mix ecto.create
Start your Phoenix app with:
    $ mix phx.server
You can also run your app inside IEx (Interactive Elixir) as:
    $ iex -S mix phx.server




```
curl -X POST http://localhost:4000/api/images/process

```

5. Estrutura de Diretórios Sugerida:
priv/
├── static/
│   ├── uploads/          # Imagens uploadadas
│   └── results/          # Resultados do processamento
└── python/
    ├── process_image.py  # Script principal
    ├── models/           # Modelos treinados
    └── requirements.txt  # Dependências Python
Essa estrutura permite que você processe as imagens uploadadas usando diferentes métodos de deep learning, mantendo flexibilidade para escolher a abordagem mais adequada ao seu caso de uso específico.