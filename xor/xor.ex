## Projeto : xor
# file : xor/xor.exs

defmodule Neuron do
  defstruct weights: [], bias: 0.0

  # Initialize a new neuron with random weights and bias
  def new(num_inputs) do
    bound = :math.sqrt(6.0 / (num_inputs + 1))
    weights = Enum.map(1..num_inputs, fn _ -> :rand.uniform() * 2 * bound - bound end)
    bias = :rand.uniform() * 2 * bound - bound
    %__MODULE__{weights: weights, bias: bias}
  end

  # Activate the neuron with given inputs and activation function
  def activate(%__MODULE__{weights: weights, bias: bias}, inputs, activation_fn) do
    sum =
      Enum.zip(weights, inputs)
      |> Enum.map(fn {w, x} -> w * x end)
      |> Enum.sum()
      |> Kernel.+(bias)

    case activation_fn do
      :tanh -> :math.tanh(sum)
      :sigmoid -> 1.0 / (1.0 + :math.exp(-sum))
      _ -> raise "Unsupported activation function"
    end
  end

  # Derivative of activation function
  def activation_derivative(output, activation_fn) do
    case activation_fn do
      :tanh -> 1.0 - output * output
      :sigmoid -> output * (1.0 - output)
      _ -> raise "Unsupported activation function"
    end
  end

  # Convert neuron to map for serialization
  def to_map(%__MODULE__{weights: weights, bias: bias}) do
    %{weights: weights, bias: bias}
  end

  # Create neuron from map (deserialization)
  def from_map(%{weights: weights, bias: bias}) do
    %__MODULE__{weights: weights, bias: bias}
  end
end

defmodule MLP do
  defstruct layers: []

  # Initialize a new MLP with given layer sizes
  def new(layer_sizes) do
    layers =
      Enum.chunk_every(layer_sizes, 2, 1, :discard)
      |> Enum.map(fn [num_inputs, num_neurons] ->
        Enum.map(1..num_neurons, fn _ -> Neuron.new(num_inputs) end)
      end)

    %__MODULE__{layers: layers}
  end

  # Perform a forward pass through the network
  def forward(%__MODULE__{layers: layers}, inputs) do
    {_, all_activations} =
      Enum.reduce(layers, {inputs, [inputs]}, fn layer, {current_inputs, activations} ->
        activation_fn = if layer == List.last(layers), do: :sigmoid, else: :tanh

        new_outputs =
          Enum.map(layer, fn neuron ->
            Neuron.activate(neuron, current_inputs, activation_fn)
          end)

        {new_outputs, activations ++ [new_outputs]}
      end)

    all_activations
  end

  # Train the network using backpropagation
  def train(mlp, training_data, learning_rate, epochs) do
    Enum.reduce(1..epochs, mlp, fn epoch, current_mlp ->
      {total_error, updated_mlp} =
        Enum.reduce(training_data, {0.0, current_mlp}, fn {inputs, targets},
                                                          {error_acc, mlp_acc} ->
          # Forward pass
          activations = forward(mlp_acc, inputs)
          output = List.last(activations)

          # Calculate output error (MSE)
          output_errors =
            Enum.zip(output, targets)
            |> Enum.map(fn {o, t} -> t - o end)

          mse = Enum.sum(Enum.map(output_errors, fn e -> e * e end)) / length(output_errors)
          total_error = error_acc + mse

          # Backpropagation - calculate deltas for each layer
          deltas = calculate_deltas(mlp_acc.layers, activations, output_errors)

          # Update weights and biases
          updated_layers = update_weights(mlp_acc.layers, deltas, activations, learning_rate)

          {total_error, %{mlp_acc | layers: updated_layers}}
        end)

      avg_error = total_error / length(training_data)

      if rem(epoch, 5000) == 0 or epoch <= 10 do
        IO.puts("Epoch #{epoch}: Average Error = #{Float.round(avg_error, 6)}")
      end

      updated_mlp
    end)
  end

  # Calculate deltas for backpropagation
  defp calculate_deltas(layers, activations, output_errors) do
    num_layers = length(layers)

    Enum.reduce((num_layers - 1)..0, [], fn layer_idx, deltas_acc ->
      layer_outputs = Enum.at(activations, layer_idx + 1)

      if layer_idx == num_layers - 1 do
        # Output layer
        activation_fn = :sigmoid

        layer_deltas =
          Enum.zip(output_errors, layer_outputs)
          |> Enum.map(fn {err, out} ->
            err * Neuron.activation_derivative(out, activation_fn)
          end)

        [layer_deltas | deltas_acc]
      else
        # Hidden layer
        activation_fn = :tanh
        next_layer = Enum.at(layers, layer_idx + 1)
        next_deltas = List.first(deltas_acc)

        layer_deltas =
          Enum.with_index(layer_outputs)
          |> Enum.map(fn {out, neuron_idx} ->
            error_sum =
              Enum.zip(next_layer, next_deltas)
              |> Enum.map(fn {neuron, delta} ->
                Enum.at(neuron.weights, neuron_idx) * delta
              end)
              |> Enum.sum()

            error_sum * Neuron.activation_derivative(out, activation_fn)
          end)

        [layer_deltas | deltas_acc]
      end
    end)
  end

  # Update weights and biases
  defp update_weights(layers, deltas, activations, learning_rate) do
    Enum.zip([layers, deltas, activations])
    |> Enum.map(fn {layer, layer_deltas, layer_inputs} ->
      Enum.zip(layer, layer_deltas)
      |> Enum.map(fn {neuron, delta} ->
        updated_weights =
          Enum.zip(neuron.weights, layer_inputs)
          |> Enum.map(fn {w, input} ->
            w + learning_rate * delta * input
          end)

        updated_bias = neuron.bias + learning_rate * delta

        %{neuron | weights: updated_weights, bias: updated_bias}
      end)
    end)
  end

  # Predict function that returns true/false based on threshold
  def predict(mlp, inputs, threshold \\ 0.5) do
    output = forward(mlp, inputs) |> List.last() |> List.first()
    output >= threshold
  end

  # Save MLP to JSON file (using native Elixir term format)
  def save_to_file(mlp, filename) do
    mlp_data = %{
      layers:
        Enum.map(mlp.layers, fn layer ->
          Enum.map(layer, fn neuron ->
            %{weights: neuron.weights, bias: neuron.bias}
          end)
        end)
    }

    # Convert to string representation
    content = inspect(mlp_data, pretty: true, limit: :infinity)

    case File.write(filename, content) do
      :ok ->
        IO.puts("✅ Rede neural salva em: #{filename}")
        :ok

      {:error, reason} ->
        IO.puts("❌ Erro ao salvar arquivo: #{reason}")
        {:error, reason}
    end
  end

  # Load MLP from file (using native Elixir term format)
  def load_from_file(filename) do
    case File.read(filename) do
      {:ok, content} ->
        try do
          {mlp_data, _} = Code.eval_string(content)

          layers =
            Enum.map(mlp_data.layers, fn layer_data ->
              Enum.map(layer_data, fn neuron_data ->
                %Neuron{weights: neuron_data.weights, bias: neuron_data.bias}
              end)
            end)

          mlp = %__MODULE__{layers: layers}
          IO.puts("✅ Rede neural carregada de: #{filename}")
          {:ok, mlp}
        rescue
          error ->
            IO.puts("❌ Erro ao carregar dados: #{inspect(error)}")
            {:error, error}
        end

      {:error, reason} ->
        IO.puts("❌ Erro ao ler arquivo: #{reason}")
        {:error, reason}
    end
  end
end

# Main function to test the MLP
defmodule Main do
  @model_file "xor_model.exs"

  def run do
    IO.puts("=== Rede Neural XOR ===\n")
    IO.puts("Comandos disponíveis:")
    IO.puts("1. treinar - Treina e salva a rede neural")
    IO.puts("2. testar - Carrega rede treinada e permite entrada interativa")
    IO.puts("3. sair - Encerra o programa")

    menu_loop()
  end

  defp menu_loop do
    IO.write("\n> Digite um comando: ")

    case String.trim(IO.read(:line)) do
      "treinar" ->
        train_and_save()

      "testar" ->
        interactive_test()

      "sair" ->
        IO.puts("👋 Até logo!")
        :ok

      command ->
        IO.puts("❌ Comando '#{command}' não reconhecido.")
        menu_loop()
    end
  end

  defp train_and_save do
    IO.puts("\n=== Treinamento da Rede Neural XOR ===")

    # Configuração da rede: 2 inputs, 4 neurônios na camada oculta, 1 output
    layer_sizes = [2, 4, 1]
    mlp = MLP.new(layer_sizes)

    # Dados de treinamento para XOR
    training_data = [
      # 0 XOR 0 = 0
      {[0.0, 0.0], [0.0]},
      # 0 XOR 1 = 1
      {[0.0, 1.0], [1.0]},
      # 1 XOR 0 = 1
      {[1.0, 0.0], [1.0]},
      # 1 XOR 1 = 0
      {[1.0, 1.0], [0.0]}
    ]

    # Treinar a rede
    IO.puts("Iniciando treinamento...")
    trained_mlp = MLP.train(mlp, training_data, 0.7, 50000)

    # Salvar modelo treinado
    MLP.save_to_file(trained_mlp, @model_file)

    # Testar o modelo treinado
    IO.puts("\n=== Resultados dos Testes ===")
    test_model(trained_mlp)

    menu_loop()
  end

  defp interactive_test do
    case MLP.load_from_file(@model_file) do
      {:ok, mlp} ->
        IO.puts("\n=== Modo Interativo ===")
        IO.puts("Digite dois valores (0 ou 1) separados por espaço.")
        IO.puts("Digite 'menu' para voltar ao menu principal.")

        interactive_loop(mlp)

      {:error, _} ->
        IO.puts("❌ Não foi possível carregar o modelo. Execute 'treinar' primeiro.")
        menu_loop()
    end
  end

  defp interactive_loop(mlp) do
    IO.write("\n> Digite dois valores (ex: 1 0): ")

    case String.trim(IO.read(:line)) do
      "menu" ->
        menu_loop()

      input_str ->
        case parse_input(input_str) do
          {:ok, [val1, val2]} ->
            inputs = [val1, val2]
            output_raw = MLP.forward(mlp, inputs) |> List.last() |> List.first()
            predicted = MLP.predict(mlp, inputs)

            IO.puts("📊 Entrada: [#{val1}, #{val2}]")
            IO.puts("📈 Saída bruta: #{Float.round(output_raw, 4)}")
            IO.puts("🎯 Resultado: #{if predicted, do: "VERDADEIRO (1)", else: "FALSO (0)"}")

            # Mostrar explicação XOR
            expected_xor = (val1 == 1.0 and val2 == 0.0) or (val1 == 0.0 and val2 == 1.0)
            status = if predicted == expected_xor, do: "✅ Correto!", else: "❌ Incorreto!"

            IO.puts(
              "🔍 XOR esperado: #{if expected_xor, do: "VERDADEIRO", else: "FALSO"} - #{status}"
            )

          {:error, reason} ->
            IO.puts("❌ #{reason}")
        end

        interactive_loop(mlp)
    end
  end

  defp parse_input(input_str) do
    case String.split(input_str) do
      [val1_str, val2_str] ->
        with {val1, ""} <- Float.parse(val1_str),
             {val2, ""} <- Float.parse(val2_str) do
          cond do
            val1 not in [0.0, 1.0] or val2 not in [0.0, 1.0] ->
              {:error, "Os valores devem ser 0 ou 1"}

            true ->
              {:ok, [val1, val2]}
          end
        else
          _ -> {:error, "Formato inválido. Digite dois números separados por espaço (ex: 1 0)"}
        end

      _ ->
        {:error, "Digite exatamente dois valores separados por espaço"}
    end
  end

  defp test_model(mlp) do
    test_cases = [
      {[0.0, 0.0], false},
      {[0.0, 1.0], true},
      {[1.0, 0.0], true},
      {[1.0, 1.0], false}
    ]

    results =
      Enum.map(test_cases, fn {input, expected} ->
        output_raw = MLP.forward(mlp, input) |> List.last() |> List.first()
        predicted = MLP.predict(mlp, input)

        status = if predicted == expected, do: "✅", else: "❌"
        correct = predicted == expected

        IO.puts(
          "Input: #{inspect(input)} | Raw: #{Float.round(output_raw, 4)} | Predicted: #{predicted} | Expected: #{expected} #{status}"
        )

        correct
      end)

    correct_predictions = Enum.count(results, & &1)
    accuracy = correct_predictions / length(test_cases) * 100

    IO.puts("\n=== Resumo ===")
    IO.puts("Acertos: #{correct_predictions}/#{length(test_cases)}")
    IO.puts("Precisão: #{Float.round(accuracy, 1)}%")

    if accuracy == 100.0 do
      IO.puts("🎉 Rede neural treinada com sucesso! XOR aprendido corretamente.")
    else
      IO.puts("⚠️ Rede precisa de mais treinamento ou ajustes nos parâmetros.")
    end
  end
end

# Iniciar o programa diretamente
Main.run()

# Para executar: elixir xor.exs

#  elixir xor.ex
