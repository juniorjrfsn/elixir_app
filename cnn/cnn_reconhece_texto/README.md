# CnnReconheceTexto

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `cnn_reconhece_texto` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:cnn_reconhece_texto, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/cnn_reconhece_texto>.



```
mix new cnn_reconhece_texto
cd cnn_reconhece_texto

mix deps.get

mix compile

mix run -e "CnnReconheceTexto.TextClassifier.train_model()"

mix run -e "CnnReconheceTexto.TextClassifier.test_model()"

```

lib/
  cnn_reconhece_texto/
    application.ex
    model/
      cnn.ex
      layer.ex
      loss.ex
      optimizer.ex
    utils/
      image_processing.ex
      file_handling.ex
      tensor_operations.ex
    training.ex
    inference.ex
mix.exs
README.md