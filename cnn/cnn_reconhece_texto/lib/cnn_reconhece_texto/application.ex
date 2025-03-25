# file: lib/cnn_reconhece_texto/application.ex
defmodule CnnReconheceTexto.Application do
  @moduledoc """
  Ponto de entrada da aplicação.
  """

  alias CnnReconheceTexto.Training
  alias CnnReconheceTexto.Inference

  def main(args) do
    case args do
      ["train"] ->
        Training.train_model()

      ["infer", image_path] ->
        # Carrega o modelo treinado (simulação)
        model = %{}
        Inference.predict(image_path, model)

      _ ->
        IO.puts("Uso: mix run -- [train|infer <imagem>]")
    end
  end
end