# file: lib/cnn_reconhece_texto/cm/utils/training.ex
defmodule CnnReconheceTexto.CM.Utils.Training do
  @moduledoc """
  Funções utilitárias para treinamento do modelo.
  """

  alias CnnReconheceTexto.Model.CNN
  alias CnnReconheceTexto.Utils.ImageProcessing

  @doc """
  Treina o modelo com base nas imagens geradas a partir de caracteres e fontes.
  """
  def train_model do
    char_classes = String.to_charlist("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
    font_dir = "dados/FontsTrain"
    fonts = list_fonts(font_dir)

    if Enum.empty?(fonts) do
      raise "Nenhuma fonte encontrada no diretório #{font_dir}"
    end

    # Inicializa o modelo CNN
    model = CNN.new({1, 28, 28}, length(char_classes))

    # Loop de treinamento
    Enum.reduce(0..149, model, fn epoch, current_model ->
      {total_loss, correct, total} =
        Enum.reduce(fonts, {0.0, 0, 0}, fn font_path, {loss_acc, correct_acc, total_acc} ->
          Enum.reduce(Enum.with_index(char_classes), {loss_acc, correct_acc, total_acc}, fn {ch, i}, {l_acc, c_acc, t_acc} ->
            # Gera a imagem com o caractere
            image_path = ImageProcessing.generate_char_image(ch, 28, font_path)

            # Processa a imagem
            input =
              image_path
              |> ImageProcessing.load_image()
              |> ImageProcessing.normalize_image()
              |> ImageProcessing.convert_to_grayscale()
              |> ImageProcessing.resize_image(28, 28)

            File.rm(image_path)

            # Cria o rótulo (one-hot encoding)
            target = create_target(length(char_classes), i)

            # Forward pass
            {output, _gradients} = CNN.forward(current_model, input)

            # Backward pass e atualização dos pesos
            new_model = CNN.train(current_model, input, target)

            # Calcula a perda
            loss = calculate_loss(output, target)

            # Avalia a previsão
            predicted_idx = CNN.predict(new_model, input)
            new_correct = if predicted_idx == i, do: c_acc + 1, else: c_acc

            {l_acc + loss, new_correct, t_acc + 1}
          end)
        end)

      accuracy = correct / total * 100
      IO.puts("Epoch #{epoch}: Loss #{total_loss / total}, Accuracy #{accuracy}%")

      current_model
    end)
  end

  @doc """
  Lista todas as fontes disponíveis no diretório especificado.
  """
  defp list_fonts(font_dir) do
    Path.wildcard("#{font_dir}/*.ttf")
  end

  @doc """
  Cria um vetor one-hot encoding para o rótulo.
  """
  defp create_target(output_size, index) do
    Nx.tensor(List.duplicate(0.0, output_size), type: :f32)
    |> Nx.put_slice([index], Nx.tensor([1.0], type: :f32))
  end

  @doc """
  Calcula a perda usando entropia cruzada.
  """
  defp calculate_loss(output, target) do
    Nx.sum(Nx.multiply(target, Nx.log(Nx.max(output, 1.0e-10)))) |> Nx.negate()
  end
end