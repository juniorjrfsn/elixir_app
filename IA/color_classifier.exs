## Projeto : IA
# file : IA/color_classifier.exs
defmodule ColorClassifier do
  # Training Data
  @training_data [
    {[255, 0, 0], "Vermelho"},
    {[200, 0, 70], "Vermelho"},
    {[255, 0, 127], "Rose"},
    {[30, 10, 240], "Azul"},
    {[0, 0, 255], "Azul"},
    {[127, 0, 0], "Vermelho"},
    {[255, 127, 0], "Laranja"},
    {[127, 127, 0], "Amarelo"},
    {[255, 255, 0], "Amarelo"},
    {[127, 255, 0], "Primavera"},
    {[0, 127, 0], "Verde"},
    {[0, 255, 0], "Verde"},
    {[0, 255, 127], "Turquesa"},
    {[0, 127, 127], "Ciano"},
    {[0, 255, 255], "Ciano"},
    {[0, 127, 255], "Cobalto"},
    {[0, 0, 127], "Azul"},
    {[0, 0, 255], "Azul"},
    {[127, 0, 255], "Violeta"},
    {[127, 0, 127], "Magenta"},
    {[255, 0, 255], "Magenta"},
    {[0, 0, 0], "Preto"},
    {[127, 127, 127], "Cinza"},
    {[255, 255, 255], "Branco"}
  ]

  # Activation Functions
  defp relu(x), do: max(0.0, x)
  defp relu_derivative(x), do: if(x > 0, do: 1.0, else: 0.0)

  # Softmax Function (Stable)
  defp softmax(output) do
    max_val = Enum.max(output)
    exps = Enum.map(output, fn x -> :math.exp(x - max_val) end)
    sum = Enum.sum(exps)
    if sum > 0, do: Enum.map(exps, fn x -> x / sum end), else: output
  end

  # Cross-Entropy Loss
  defp cross_entropy_loss(target, output) do
    Enum.zip_with(target, output, fn t, o ->
      -t * :math.log(max(o, 1.0e-15))
    end)
    |> Enum.sum()
  end

  # Initialize Weights and Biases (Xavier/Glorot Initialization)
  defp initialize_weights(input_size, hidden_size, output_size) do
    :rand.seed(:exrop, :erlang.timestamp())

    weights_input_hidden =
      for _ <- 1..hidden_size do
        for _ <- 1..input_size do
          limit = :math.sqrt(6.0 / (input_size + hidden_size))
          (:rand.uniform() - 0.5) * 2 * limit
        end
      end

    weights_hidden_output =
      for _ <- 1..output_size do
        for _ <- 1..hidden_size do
          limit = :math.sqrt(6.0 / (hidden_size + output_size))
          (:rand.uniform() - 0.5) * 2 * limit
        end
      end

    bias_hidden = for _ <- 1..hidden_size, do: 0.0
    bias_output = for _ <- 1..output_size, do: 0.0

    {weights_input_hidden, weights_hidden_output, bias_hidden, bias_output}
  end

  # Dot Product
  defp dot_product(vec1, vec2) do
    Enum.zip_with(vec1, vec2, fn a, b -> a * b end) |> Enum.sum()
  end

  # Matrix-Vector Multiplication
  defp mat_vec_mult(matrix, vector) do
    Enum.map(matrix, fn row -> dot_product(row, vector) end)
  end

  # Vector Addition
  defp vec_add(vec1, vec2) do
    Enum.zip_with(vec1, vec2, fn a, b -> a + b end)
  end

  # Forward Propagation
  defp forward(inputs, weights_input_hidden, weights_hidden_output, bias_hidden, bias_output) do
    # Hidden layer
    hidden_inputs = mat_vec_mult(weights_input_hidden, inputs)
    hidden_inputs_with_bias = vec_add(hidden_inputs, bias_hidden)
    hidden_outputs = Enum.map(hidden_inputs_with_bias, &relu/1)

    # Output layer
    output_inputs = mat_vec_mult(weights_hidden_output, hidden_outputs)
    output_inputs_with_bias = vec_add(output_inputs, bias_output)
    outputs = softmax(output_inputs_with_bias)

    {hidden_outputs, outputs}
  end

  # Backpropagation and Weight Updates
  defp train_step(
         inputs,
         target,
         weights_input_hidden,
         weights_hidden_output,
         bias_hidden,
         bias_output,
         learning_rate
       ) do
    # Forward propagation
    {hidden_outputs, outputs} =
      forward(inputs, weights_input_hidden, weights_hidden_output, bias_hidden, bias_output)

    # Calculate output layer gradients
    output_errors = Enum.zip_with(target, outputs, fn t, o -> o - t end)

    # Calculate hidden layer gradients
    hidden_errors =
      Enum.with_index(hidden_outputs)
      |> Enum.map(fn {h, i} ->
        error =
          Enum.with_index(weights_hidden_output)
          |> Enum.map(fn {row, _} -> Enum.at(row, i) end)
          |> dot_product(output_errors)

        error * relu_derivative(h)
      end)

    # Update weights and biases for output layer
    new_weights_hidden_output =
      Enum.with_index(weights_hidden_output)
      |> Enum.map(fn {row, i} ->
        error = Enum.at(output_errors, i)

        Enum.zip_with(row, hidden_outputs, fn w, h ->
          w - learning_rate * error * h
        end)
      end)

    new_bias_output =
      Enum.zip_with(bias_output, output_errors, fn b, e ->
        b - learning_rate * e
      end)

    # Update weights and biases for hidden layer
    new_weights_input_hidden =
      Enum.with_index(weights_input_hidden)
      |> Enum.map(fn {row, i} ->
        error = Enum.at(hidden_errors, i)

        Enum.zip_with(row, inputs, fn w, inp ->
          w - learning_rate * error * inp
        end)
      end)

    new_bias_hidden =
      Enum.zip_with(bias_hidden, hidden_errors, fn b, e ->
        b - learning_rate * e
      end)

    {new_weights_input_hidden, new_weights_hidden_output, new_bias_hidden, new_bias_output}
  end

  # Save Model to Binary File
  defp save_model(model, colors, path) do
    File.mkdir_p!(Path.dirname(path))

    # Serialize the model and colors into binary format
    data =
      {model[:weights_input_hidden], model[:weights_hidden_output], model[:bias_hidden],
       model[:bias_output], colors}

    binary_data = :erlang.term_to_binary(data)
    File.write!(path, binary_data)
    IO.puts("Modelo salvo em #{path}")
  end

  # Load Model from Binary File
  defp load_model(path) do
    case File.read(path) do
      {:ok, content} ->
        case :erlang.binary_to_term(content) do
          {wih, who, bh, bo, colors} ->
            {{wih, who, bh, bo}, colors}

          _ ->
            IO.puts("Erro ao carregar modelo: formato de arquivo inválido")
            nil
        end

      {:error, reason} ->
        IO.puts("Erro ao carregar modelo: #{reason}")
        nil
    end
  end

  # Train the Model
  def train_model(epochs \\ 5000, learning_rate \\ 0.1) do
    colors = Enum.map(@training_data, &elem(&1, 1)) |> Enum.uniq() |> Enum.sort()
    color_idx = Enum.with_index(colors) |> Map.new()

    inputs =
      Enum.map(@training_data, fn {rgb, _} ->
        Enum.map(rgb, fn x -> x / 255.0 end)
      end)

    targets =
      Enum.map(@training_data, fn {_, label} ->
        one_hot = List.duplicate(0.0, length(colors))
        List.replace_at(one_hot, color_idx[label], 1.0)
      end)

    {weights_input_hidden, weights_hidden_output, bias_hidden, bias_output} =
      initialize_weights(3, 32, length(colors))

    IO.puts("Treinando novo modelo...")
    IO.puts("Épocas: #{epochs}, Taxa de aprendizado: #{learning_rate}")
    IO.puts("Classes: #{inspect(colors)}")

    {final_wih, final_who, final_bh, final_bo} =
      Enum.reduce(
        1..epochs,
        {weights_input_hidden, weights_hidden_output, bias_hidden, bias_output},
        fn epoch, {wih, who, bh, bo} ->
          # Embaralhar dados de treinamento
          shuffled_data = Enum.zip(inputs, targets) |> Enum.shuffle()

          # Treinar com todos os exemplos
          {new_wih, new_who, new_bh, new_bo} =
            Enum.reduce(shuffled_data, {wih, who, bh, bo}, fn {inp, tgt}, {w1, w2, b1, b2} ->
              train_step(inp, tgt, w1, w2, b1, b2, learning_rate)
            end)

          # Mostrar progresso
          if rem(epoch, 500) == 0 do
            total_loss =
              Enum.zip(inputs, targets)
              |> Enum.map(fn {inp, tgt} ->
                {_, outputs} = forward(inp, new_wih, new_who, new_bh, new_bo)
                cross_entropy_loss(tgt, outputs)
              end)
              |> Enum.sum()

            accuracy =
              Enum.zip(inputs, targets)
              |> Enum.map(fn {inp, tgt} ->
                {_, outputs} = forward(inp, new_wih, new_who, new_bh, new_bo)

                predicted_idx =
                  Enum.with_index(outputs)
                  |> Enum.max_by(fn {val, _} -> val end)
                  |> elem(1)

                expected_idx =
                  Enum.with_index(tgt)
                  |> Enum.max_by(fn {val, _} -> val end)
                  |> elem(1)

                if predicted_idx == expected_idx, do: 1, else: 0
              end)
              |> Enum.sum()
              |> Kernel./(length(inputs))

            IO.puts(
              "Época #{epoch} | Loss: #{Float.round(total_loss, 4)} | Acurácia: #{Float.round(accuracy * 100, 2)}%"
            )
          end

          {new_wih, new_who, new_bh, new_bo}
        end
      )

    model = %{
      weights_input_hidden: final_wih,
      weights_hidden_output: final_who,
      bias_hidden: final_bh,
      bias_output: final_bo
    }

    save_model(model, colors, "dados/color_classifier.dat")
    IO.puts("Treinamento concluído!")
  end

  # Predict
  def predict(rgb, weights_input_hidden, weights_hidden_output, bias_hidden, bias_output, colors) do
    inputs = Enum.map(rgb, fn x -> x / 255.0 end)

    {_, outputs} =
      forward(inputs, weights_input_hidden, weights_hidden_output, bias_hidden, bias_output)

    {confidence, max_idx} =
      Enum.with_index(outputs)
      |> Enum.max_by(fn {val, _} -> val end)

    predicted =
      if max_idx < length(colors) do
        Enum.at(colors, max_idx)
      else
        "Desconhecido"
      end

    {predicted, confidence * 100}
  end

  # Interactive Mode
  defp interactive_mode(model, colors) do
    {weights_input_hidden, weights_hidden_output, bias_hidden, bias_output} = model

    IO.puts("\n=== MODO INTERATIVO ===")
    IO.puts("Digite valores RGB (ex: 255,0,0) ou 'sair' para terminar:")

    case IO.gets("RGB> ") |> String.trim() do
      "sair" ->
        IO.puts("Saindo...")

      input ->
        case String.split(input, ",") do
          [r, g, b] ->
            try do
              rgb = [
                String.to_integer(String.trim(r)),
                String.to_integer(String.trim(g)),
                String.to_integer(String.trim(b))
              ]

              if Enum.all?(rgb, fn x -> x >= 0 and x <= 255 end) do
                {predicted, confidence} =
                  predict(
                    rgb,
                    weights_input_hidden,
                    weights_hidden_output,
                    bias_hidden,
                    bias_output,
                    colors
                  )

                IO.puts("RGB: #{inspect(rgb)} → #{predicted} (#{Float.round(confidence, 1)}%)")
              else
                IO.puts("Erro: valores RGB devem estar entre 0 e 255")
              end

              interactive_mode(model, colors)
            rescue
              _ ->
                IO.puts("Erro: formato inválido. Use: R,G,B (ex: 255,0,0)")
                interactive_mode(model, colors)
            end

          _ ->
            IO.puts("Erro: formato inválido. Use: R,G,B (ex: 255,0,0)")
            interactive_mode(model, colors)
        end
    end
  end

  # Main Function
  def main(args) do
    case args do
      ["treino"] ->
        train_model()

      ["reconhecer"] ->
        model_path = "dados/color_classifier.dat"

        case load_model(model_path) do
          {model, colors} ->
            {weights_input_hidden, weights_hidden_output, bias_hidden, bias_output} = model

            test_data = [
              # Vermelho
              [200, 0, 70],
              # Azul
              [30, 10, 240],
              # Vermelho puro
              [255, 0, 0],
              # Verde puro
              [0, 255, 0],
              # Azul puro
              [0, 0, 255],
              # Amarelo
              [255, 255, 0],
              # Magenta
              [255, 0, 255],
              # Ciano
              [0, 255, 255],
              # Cinza
              [128, 128, 128]
            ]

            IO.puts("\n================ TESTE AUTOMÁTICO ===============")

            Enum.each(test_data, fn rgb ->
              {predicted, confidence} =
                predict(
                  rgb,
                  weights_input_hidden,
                  weights_hidden_output,
                  bias_hidden,
                  bias_output,
                  colors
                )

              IO.puts(
                "RGB: #{inspect(rgb) |> String.pad_trailing(15)} | Previsão: #{String.pad_trailing(predicted, 12)} | Confiança: #{Float.round(confidence, 1)}%"
              )
            end)

            # Modo interativo
            interactive_mode(model, colors)

          nil ->
            IO.puts("Modelo não encontrado. Execute primeiro: elixir color_classifier.exs treino")
        end

      ["treino", epochs_str] ->
        case Integer.parse(epochs_str) do
          {epochs, ""} when epochs > 0 ->
            train_model(epochs)

          _ ->
            IO.puts("Número de épocas inválido: #{epochs_str}")
        end

      _ ->
        IO.puts("Uso:")
        IO.puts("  elixir color_classifier.exs treino [épocas]")
        IO.puts("  elixir color_classifier.exs reconhecer")
        IO.puts("")
        IO.puts("Exemplos:")
        IO.puts("  elixir color_classifier.exs treino")
        IO.puts("  elixir color_classifier.exs treino 10000")
        IO.puts("  elixir color_classifier.exs reconhecer")
    end
  end
end

# Run the Script
ColorClassifier.main(System.argv())

## Treinar o modelo
# elixir color_classifier.exs treino

## Treinar com número específico de épocas
# elixir color_classifier.exs treino 10000

## Reconhecer cores (inclui teste automático + modo interativo)
# elixir color_classifier.exs reconhecer
