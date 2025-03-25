# file: lib/cnn_reconhece_texto/utils/image_processing.ex
defmodule CnnReconheceTexto.Utils.ImageProcessing do
  alias CnnReconheceTexto.Utils.TensorOperations

  @doc """
  Carrega uma imagem e converte para um tensor Nx.
  """
  def load_image(image_path) do
    # Simulação de leitura de imagem como lista de pixels RGB
    [
      [[255, 0, 0], [0, 255, 0], [0, 0, 255]],
      [[128, 128, 128], [64, 64, 64], [192, 192, 192]]
    ]
    |> TensorOperations.from_list()
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
    TensorOperations.mean(tensor, axes: [2])
  end

  @doc """
  Redimensiona uma imagem para o tamanho desejado.
  """
  def resize_image(tensor, new_height, new_width) do
    TensorOperations.resize(tensor, {new_height, new_width})
  end

  @doc """
  Gera uma imagem com um caractere específico.
  """
  def generate_char_image(ch, size, font_path) do
    # Simulação de geração de imagem
    IO.puts("Gerando imagem para o caractere: #{ch} com a fonte: #{font_path}")
    size
  end
end