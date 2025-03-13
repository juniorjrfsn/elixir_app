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
  defp relu(x), do: max(0, x)
  defp relu_derivative(x), do: if(x > 0, do: 1, else: 0)

  # Softmax Function (Stable)
  defp softmax(output) do
    max = Enum.max(output)
    exps = Enum.map(output, &:math.exp(&1 - max))
    sum = Enum.sum(exps)
    Enum.map(exps, &(&1 / sum))
  end

  # Cross-Entropy Loss
  defp cross_entropy_loss(target, output) do
    -Enum.sum(Enum.zip_with(target, output, fn t, o -> t * :math.log(max(o, 1.0e-10)) end))
  end

  # Initialize Weights and Biases (Xavier/Glorot Initialization)
  defp initialize_weights(input_size, hidden_size, output_size) do
    :rand.seed(:exrop, :erlang.timestamp())

    weights_input_hidden =
      for _ <- 1..input_size do
        for _ <- 1..hidden_size do
          :rand.uniform() * 2 / :math.sqrt(input_size + hidden_size) - 1 / :math.sqrt(input_size + hidden_size)
        end
      end

    weights_hidden_output =
      for _ <- 1..hidden_size do
        for _ <- 1..output_size do
          :rand.uniform() * 2 / :math.sqrt(hidden_size + output_size) - 1 / :math.sqrt(hidden_size + output_size)
        end
      end

    bias_hidden = for _ <- 1..hidden_size, do: 0.0
    bias_output = for _ <- 1..output_size, do: 0.0

    {weights_input_hidden, weights_hidden_output, bias_hidden, bias_output}
  end

  # Forward Propagation
  defp forward(inputs, weights_input_hidden, weights_hidden_output, bias_hidden, bias_output) do
    hidden_inputs =
      Enum.map(weights_input_hidden, fn row ->
        dot_product(row, inputs) + Enum.sum(bias_hidden)
      end)

    hidden_outputs = Enum.map(hidden_inputs, &relu/1)

    output_inputs =
      Enum.map(weights_hidden_output, fn row ->
        dot_product(row, hidden_outputs) + Enum.sum(bias_output)
      end)

    outputs = softmax(output_inputs)

    {hidden_outputs, outputs}
  end

  # Dot Product
  defp dot_product(vec1, vec2) do
    Enum.zip(vec1, vec2) |> Enum.map(fn {a, b} -> a * b end) |> Enum.sum()
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

    # Calculate output errors
    output_errors = Enum.zip_with(outputs, target, &(&2 - &1))

    # Calculate hidden errors
    hidden_errors =
      Enum.map(weights_hidden_output, fn row ->
        dot_product(row, output_errors)
      end)
      |> Enum.zip_with(hidden_outputs, fn error, output -> error * relu_derivative(output) end)

    # Update weights_hidden_output and bias_output
    weights_hidden_output =
      Enum.zip_with(weights_hidden_output, hidden_errors, fn row, error ->
        Enum.zip_with(row, hidden_outputs, fn w, h -> w + learning_rate * error * h end)
      end)

    bias_output =
      Enum.zip_with(bias_output, output_errors, fn b, e -> b + learning_rate * e end)

    # Update weights_input_hidden and bias_hidden
    weights_input_hidden =
      Enum.zip_with(weights_input_hidden, hidden_errors, fn row, error ->
        Enum.zip_with(row, inputs, fn w, i -> w + learning_rate * error * i end)
      end)

    bias_hidden =
      Enum.zip_with(bias_hidden, hidden_errors, fn b, e -> b + learning_rate * e end)

    {weights_input_hidden, weights_hidden_output, bias_hidden, bias_output}
  end

  # Save Model to Binary File
  defp save_model(model, colors, path) do
    File.mkdir_p!(Path.dirname(path))

    # Serialize the model and colors into binary format
    data = {model[:weights_input_hidden], model[:weights_hidden_output], model[:bias_hidden], model[:bias_output], colors}
    binary_data = :erlang.term_to_binary(data)
    File.write!(path, binary_data)
    IO.puts("Model saved to #{path}")
  end

  # Load Model from Binary File
  defp load_model(path) do
    case File.read(path) do
      {:ok, content} ->
        case :erlang.binary_to_term(content) do
          {wih, who, bh, bo, colors} ->
            {{wih, who, bh, bo}, colors}

          _ ->
            IO.puts("Error loading model: Invalid file format")
            nil
        end

      {:error, reason} ->
        IO.puts("Error loading model: #{reason}")
        nil
    end
  end

  # Train the Model
  def train_model(epochs \\ 20_000, learning_rate \\ 0.01) do
    colors = Enum.map(@training_data, &elem(&1, 1)) |> Enum.uniq() |> Enum.sort()
    color_idx = Enum.with_index(colors) |> Map.new()

    inputs =
      Enum.map(@training_data, fn {rgb, _} ->
        Enum.map(rgb, &(&1 / 255.0))
      end)

    targets =
      Enum.map(@training_data, fn {_, label} ->
        one_hot = List.duplicate(0.0, length(colors))
        List.replace_at(one_hot, color_idx[label], 1.0)
      end)

    {weights_input_hidden, weights_hidden_output, bias_hidden, bias_output} =
      initialize_weights(3, 64, length(colors))

    IO.puts("Training new model...")

    {wih, who, bh, bo} =
      Enum.reduce(1..epochs, {weights_input_hidden, weights_hidden_output, bias_hidden, bias_output}, fn epoch, {wih, who, bh, bo} ->
        Enum.zip(inputs, targets)
        |> Enum.reduce({wih, who, bh, bo}, fn {inp, tgt}, acc ->
          train_step(inp, tgt, elem(acc, 0), elem(acc, 1), elem(acc, 2), elem(acc, 3), learning_rate)
        end)

        if rem(epoch, 1000) == 0 do
          loss =
            Enum.zip(inputs, targets)
            |> Enum.map(fn {inp, tgt} ->
              {_, outputs} = forward(inp, wih, who, bh, bo)
              cross_entropy_loss(tgt, outputs)
            end)
            |> Enum.sum()

          accuracy =
            Enum.zip(inputs, targets)
            |> Enum.map(fn {inp, tgt} ->
              {_, outputs} = forward(inp, wih, who, bh, bo)
              predicted = Enum.max_by(Enum.with_index(outputs), fn {val, _} -> val end) |> elem(1)
              expected = Enum.max_by(Enum.with_index(tgt), fn {val, _} -> val end) |> elem(1)
              if predicted == expected, do: 1, else: 0
            end)
            |> Enum.sum()
            |> Kernel./(length(inputs))

          IO.puts("Epoch #{epoch} | Loss: #{Float.round(loss, 4)} | Accuracy: #{Float.round(accuracy * 100, 2)}%")
        end

        {wih, who, bh, bo}
      end)

    model = %{
      weights_input_hidden: wih,
      weights_hidden_output: who,
      bias_hidden: bh,
      bias_output: bo
    }

    save_model(model, colors, "dados/color_classifier.dat")
  end

  # Predict
  def predict(rgb, weights_input_hidden, weights_hidden_output, bias_hidden, bias_output, colors) do
    inputs = Enum.map(rgb, &(&1 / 255.0))
    {_, outputs} = forward(inputs, weights_input_hidden, weights_hidden_output, bias_hidden, bias_output)
    max_idx = Enum.max_by(Enum.with_index(outputs), fn {val, _} -> val end) |> elem(1)

    # Ensure valid prediction
    predicted = if max_idx != nil and max_idx < length(colors), do: Enum.at(colors, max_idx), else: "Desconhecido"
    confidence = Enum.at(outputs, max_idx || 0) * 100
    {predicted, confidence}
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
              [200, 0, 70],
              [30, 10, 240]
            ]

            IO.puts("\n================ TESTE ===============")
            Enum.each(test_data, fn rgb ->
              {predicted, confidence} = predict(rgb, weights_input_hidden, weights_hidden_output, bias_hidden, bias_output, colors)
              IO.puts("Cor RGB: #{inspect(rgb)} | Previsão: #{String.pad_leading(predicted, 10)} | Confiança: #{Float.round(confidence, 1)}%")
            end)

          nil ->
            IO.puts("Model not found. Please train the model first using 'elixir color_classifier.exs treino'.")
        end

      _ ->
        IO.puts("Usage: elixir color_classifier.exs [treino|reconhecer]")
    end
  end
end

# Run the Script
ColorClassifier.main(System.argv())
