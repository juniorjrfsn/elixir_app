# file: lib/cnn_reconhece_texto/inference.ex
defmodule CnnReconheceTexto.Inference do
  @moduledoc """
  Módulo responsável pela inferência do modelo.
  """

  alias CnnReconheceTexto.Model.CNN
  alias CnnReconheceTexto.Utils.ImageProcessing

  @doc """
  Faz uma previsão com base na imagem fornecida.
  """
  def predict(image_path, model) do
    # Processa a imagem
    input =
      image_path
      |> ImageProcessing.load_image()
      |> ImageProcessing.normalize_image()
      |> ImageProcessing.convert_to_grayscale()
      |> ImageProcessing.resize_image(28, 28)

    # Faz a previsão usando o modelo
    CNN.predict(model, input)
  end
end