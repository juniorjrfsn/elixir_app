# file: lib/cnn_reconhece_texto/cm/utils/image_processing.ex
defmodule CnnReconheceTexto.CM.Utils.ImageProcessing do
  @moduledoc """
  Funções utilitárias para processamento de imagens.
  """

  alias CnnReconheceTexto.Utils.TensorOperations

  @doc """
  Carrega uma imagem e converte para um tensor Nx.
  """
  def load_image(image_path) do
    # Simulação de leitura de imagem como lista de pixels RGB
    image_data = read_image_as_rgb(image_path)

    # Converte para tensor Nx
    TensorOperations.from_list(image_data)
  end

  @doc """
  Normaliza uma imagem para o intervalo [0, 1].
  """
  def normalize_image(tensor) do
    TensorOperations.divide(tensor, 255.0)
  end

  @doc """
  Converte uma imagem RGB para escala de cinza.
  """
  def convert_to_grayscale(tensor) do
    # Média dos canais R, G e B
    TensorOperations.mean(tensor, axes: [2])
  end

  @doc """
  Redimensiona uma imagem para o tamanho desejado.
  """
  def resize_image(tensor, new_height, new_width) do
    # Simulação de redimensionamento usando interpolação simples
    TensorOperations.resize(tensor, {new_height, new_width})
  end

  @doc """
  Aplica transformações de aumento de dados à imagem.
  """
  def augment_image(image) do
    # Exemplo de transformação: multiplicação por um tensor aleatório
    Nx.multiply(image, Nx.random_uniform(Nx.shape(image)))
  end

  # Simulação de leitura de imagem como lista de pixels RGB
  defp read_image_as_rgb(image_path) do
    # Para fins de exemplo, retornamos uma matriz fixa
    [
      [[255, 0, 0], [0, 255, 0], [0, 0, 255]],
      [[128, 128, 128], [64, 64, 64], [192, 192, 192]]
    ]
  end
end