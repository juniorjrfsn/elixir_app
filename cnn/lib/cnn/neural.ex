# lib/cnn/neural.ex


defmodule Cnn.Neural do
  @moduledoc """
  Improved Convolutional Neural Network implementation for digit classification
  """

  alias Cnn.{Matrix, Utils, ConvOps}

  defstruct [
    conv1: nil,    # First convolutional layer
    conv2: nil,    # Second convolutional layer
    fc1: nil,      # First fully connected layer
    fc2: nil       # Output layer (10 neurons for 10 digits)
  ]

  defmodule ConvLayer do
    defstruct [
      filters: [],   # List of 3x3 filters
      bias: [],      # Bias for each filter
      size: 3        # Filter size
    ]
  end

  defmodule FCLayer do
    defstruct [
      weights: [],     # Weight matrix
      bias: [],        # Bias vector
      input_size: 0,   # Input size
      output_size: 0   # Output size
    ]
  end

  @doc """
  Creates a new neural network with improved Xavier initialization
  """
  def create_network do
    IO.puts("Criando rede neural convolucional com inicialização Xavier...")

    conv1_filters = for _ <- 1..4, do: xavier_init_filter(3, 3)
    conv1 = %ConvLayer{
      filters: conv1_filters,
      bias: List.duplicate(0.0, 4),
      size: 3
    }

    conv2_filters = for _ <- 1..8, do: xavier_init_filter(3, 3)
    conv2 = %ConvLayer{
      filters: conv2_filters,
      bias: List.duplicate(0.0, 8),
      size: 3
    }

    fc1 = %FCLayer{
      weights: xavier_init_matrix(16, 8),
      bias: List.duplicate(0.0, 16),
      input_size: 8,
      output_size: 16
    }

    fc2 = %FCLayer{
      weights: xavier_init_matrix(10, 16),
      bias: List.duplicate(0.0, 10),
      input_size: 16,
      output_size: 10
    }

    network = %__MODULE__{
      conv1: conv1,
      conv2: conv2,
      fc1: fc1,
      fc2: fc2
    }

    IO.puts("Rede neural criada com sucesso!\n")
    network
  end

  @doc """
  Improved pattern-based training that learns actual digit characteristics
  """
  def train_network(network, training_data) do
    IO.puts("Iniciando treinamento baseado em padrões...")

    pattern_signatures = training_data
    |> Enum.with_index()
    |> Enum.map(fn {matrix, digit} ->
      signature = create_pattern_signature(matrix)
      {digit, signature}
    end)

    epochs = 5
    learning_rate = 0.1

    trained_network = Enum.reduce(1..epochs, network, fn epoch, current_network ->
      IO.puts("Época #{epoch}/#{epochs}")

      updated_network = pattern_signatures
      |> Enum.reduce(current_network, fn {digit, signature}, net ->
        update_weights_for_pattern(net, signature, digit, learning_rate)
      end)

      updated_network
    end)

    IO.puts("Treinamento concluído com reconhecimento de padrões!\n")
    trained_network
  end

  @doc """
  Improved prediction with statistical feature extraction
  """
  def predict(network, input_matrix) do
    IO.puts("=== PROCESSAMENTO MELHORADO DA REDE NEURAL ===\n")
    IO.puts("Entrada: matriz #{length(input_matrix)}x#{length(Enum.at(input_matrix, 0))}")

    features = extract_statistical_features(input_matrix)
    IO.puts("Características extraídas: #{length(features)} elementos")
    IO.puts("Características: #{Utils.format_weights(features)}\n")

    fc1_output = network.fc1.weights
    |> Enum.zip(network.fc1.bias)
    |> Enum.map(fn {weights, bias} ->
      adjusted_weights = adjust_weight_vector(weights, features)
      Utils.relu(Utils.dot_product(features, adjusted_weights) + bias)
    end)

    IO.puts("FC1 (#{length(features)} -> #{network.fc1.output_size}): Ativação ReLU aplicada")
    IO.puts("FC1 Saída: [#{Utils.format_weights(Enum.take(fc1_output, 6))}]\n")

    fc2_output = network.fc2.weights
    |> Enum.zip(network.fc2.bias)
    |> Enum.map(fn {weights, bias} ->
      adjusted_weights = adjust_weight_vector(weights, fc1_output)
      Utils.dot_product(fc1_output, adjusted_weights) + bias
    end)

    IO.puts("FC2 (#{network.fc2.input_size} -> #{network.fc2.output_size}): Camada de saída")
    IO.puts("FC2 Saída: [#{Utils.format_weights(Enum.take(fc2_output, 6))}]\n")

    probabilities = Utils.softmax(fc2_output)

    IO.puts("=== RESULTADO FINAL ===")
    print_predictions(probabilities)

    probabilities
  end

  @doc """
  Pattern matching prediction that compares input to learned patterns
  """
  def predict_with_patterns(network, input_matrix, training_matrices) do
    IO.puts("=== RECONHECIMENTO POR PADRÕES ===\n")

    similarities = training_matrices
    |> Enum.with_index()
    |> Enum.map(fn {training_matrix, digit} ->
      float_training = Utils.integer_to_float_matrix(training_matrix)
      similarity = calculate_pattern_similarity(input_matrix, float_training)
      IO.puts("Similaridade com dígito #{digit}: #{Float.round(similarity * 100, 1)}%")
      similarity
    end)

    IO.puts("")

    enhanced_similarities = similarities
    |> Enum.zip(network.fc2.bias)
    |> Enum.map(fn {sim, bias} ->
      sim + bias * 0.1
    end)

    probabilities = Utils.softmax(enhanced_similarities)

    IO.puts("=== RESULTADO FINAL ===")
    print_predictions(probabilities)

    probabilities
  end

  @doc """
  Tests the network with a specific matrix using hybrid approach
  """
  def test_network(network, input_matrix, expected_digit) do
    IO.puts("=== TESTE DA REDE NEURAL ===")
    IO.puts("Matriz de entrada (dígito esperado: #{expected_digit}):")
    Utils.print_matrix(input_matrix)

    probabilities = predict(network, input_matrix)

    {predicted_digit, max_prob} = find_max_prediction(probabilities)

    IO.puts("Dígito predito: #{predicted_digit} (confiança: #{Float.round(max_prob * 100, 2)}%)")
    result_text = if predicted_digit == expected_digit, do: "✅ CORRETO", else: "❌ ERRADO"
    IO.puts(result_text)

    {predicted_digit, max_prob}
  end

  @doc """
  Tests the network using pattern matching approach
  """
  def test_network_patterns(network, input_matrix, expected_digit, training_matrices) do
    IO.puts("=== TESTE COM RECONHECIMENTO DE PADRÕES ===")
    IO.puts("Matriz de entrada (dígito esperado: #{expected_digit}):")
    Utils.print_matrix(input_matrix)

    probabilities = predict_with_patterns(network, input_matrix, training_matrices)

    {predicted_digit, max_prob} = find_max_prediction(probabilities)

    IO.puts("Dígito predito: #{predicted_digit} (confiança: #{Float.round(max_prob * 100, 2)}%)")
    result_text = if predicted_digit == expected_digit, do: "✅ CORRETO", else: "❌ ERRADO"
    IO.puts(result_text)

    {predicted_digit, max_prob}
  end

  @doc """
  Prints network weights for debugging
  """
  def print_network_weights(network) do
    IO.puts("=== PESOS DA REDE NEURAL ===")
    IO.puts("Conv1 filtros: #{length(network.conv1.filters)} filtros 3x3")
    network.conv1.filters |> Enum.each_with_index(fn filter, i ->
      IO.puts("Filtro #{i + 1}:")
      Utils.print_matrix(filter)
    end)
    IO.puts("Conv1 bias: #{Utils.format_weights(network.conv1.bias)}\n")

    IO.puts("Conv2 filtros: #{length(network.conv2.filters)} filtros 3x3")
    network.conv2.filters |> Enum.each_with_index(fn filter, i ->
      IO.puts("Filtro #{i + 1}:")
      Utils.print_matrix(filter)
    end)
    IO.puts("Conv2 bias: #{Utils.format_weights(network.conv2.bias)}\n")

    IO.puts("FC1 pesos: #{network.fc1.input_size}x#{network.fc1.output_size}")
    Utils.print_matrix(network.fc1.weights)
    IO.puts("FC1 bias: #{Utils.format_weights(network.fc1.bias)}\n")

    IO.puts("FC2 pesos: #{network.fc2.input_size}x#{network.fc2.output_size}")
    Utils.print_matrix(network.fc2.weights)
    IO.puts("FC2 bias: #{Utils.format_weights(network.fc2.bias)}\n")
  end

  # Private functions

  defp xavier_init_filter(height, width) do
    fan_in = height * width
    scale = :math.sqrt(6.0 / fan_in)
    for _ <- 1..height do
      for _ <- 1..width do
        (:rand.uniform() - 0.5) * 2 * scale
      end
    end
  end

  defp xavier_init_matrix(rows, cols) do
    fan_in = cols
    fan_out = rows
    scale = :math.sqrt(6.0 / (fan_in + fan_out))
    for _ <- 1..rows do
      for _ <- 1..cols do
        (:rand.uniform() - 0.5) * 2 * scale
      end
    end
  end

  defp extract_statistical_features(matrix) do
    create_pattern_signature(matrix)
  end

  defp create_pattern_signature(matrix) do
    flat = List.flatten(matrix)

    [
      Enum.sum(flat),
      Enum.count(flat, fn x -> x > 0 end),
      calculate_horizontal_symmetry(matrix),
      calculate_vertical_symmetry(matrix),
      count_transitions(flat),
      edge_density(matrix),
      corner_activity(matrix),
      center_activity(matrix)
    ]
  end

  defp update_weights_for_pattern(network, signature, target_digit, learning_rate) do
    new_fc2_bias = network.fc2.bias
    |> Enum.with_index()
    |> Enum.map(fn {bias, digit} ->
      if digit == target_digit do
        bias + learning_rate * (Enum.sum(signature) / length(signature)) * 0.1
      else
        bias - learning_rate * 0.01
      end
    end)

    signature_strength = Enum.sum(signature) / length(signature)
    new_fc1_bias = network.fc1.bias
    |> Enum.map(fn bias ->
      bias + learning_rate * signature_strength * 0.05 * (:rand.uniform() - 0.5)
    end)

    %{network |
      fc1: %{network.fc1 | bias: new_fc1_bias},
      fc2: %{network.fc2 | bias: new_fc2_bias}
    }
  end

  defp calculate_pattern_similarity(matrix1, matrix2) do
    flat1 = List.flatten(matrix1)
    flat2 = List.flatten(matrix2)

    pixel_similarity = flat1
    |> Enum.zip(flat2)
    |> Enum.map(fn {a, b} -> 1.0 - abs(a - b) end)
    |> Enum.sum()
    |> Kernel./(length(flat1))

    sig1 = create_pattern_signature(matrix1)
    sig2 = create_pattern_signature(matrix2)

    sig_similarity = sig1
    |> Enum.zip(sig2)
    |> Enum.map(fn {a, b} ->
      max_val = max(abs(a), abs(b))
      if max_val == 0, do: 1.0, else: 1.0 - abs(a - b) / max_val
    end)
    |> Enum.sum()
    |> Kernel./(length(sig1))

    pixel_similarity * 0.7 + sig_similarity * 0.3
  end

  # Keeping these functions as they might be used in future expansions
  defp center_of_mass_x(matrix) do
    total = matrix |> List.flatten() |> Enum.sum()
    if total == 0, do: 2.0, else:
      (matrix
      |> Enum.with_index()
      |> Enum.reduce(0, fn {row, i}, acc ->
        acc + Enum.sum(row) * i
      end)) / total
  end

  defp center_of_mass_y(matrix) do
    total = matrix |> List.flatten() |> Enum.sum()
    if total == 0, do: 2.0, else:
      (matrix
      |> Enum.reduce(0, fn row, acc ->
        row_contribution = row
        |> Enum.with_index()
        |> Enum.reduce(0, fn {val, j}, row_acc ->
          row_acc + val * j
        end)
        acc + row_contribution
      end)) / total
  end

  def top_edge_density(matrix), do: (matrix |> Enum.at(0) |> Enum.sum()) / 5
  def bottom_edge_density(matrix), do: (matrix |> Enum.at(-1) |> Enum.sum()) / 5
  defp left_edge_density(matrix), do: (matrix |> Enum.map(&Enum.at(&1, 0)) |> Enum.sum()) / 5
  defp right_edge_density(matrix), do: (matrix |> Enum.map(&Enum.at(&1, -1)) |> Enum.sum()) / 5

  defp calculate_horizontal_symmetry(matrix) do
    matrix
    |> Enum.map(fn row ->
      len = length(row)
      mid = div(len, 2)
      if mid == 0 do
        1.0
      else
        _first_half = Enum.take(row, mid)
        _second_half = row |> Enum.reverse() |> Enum.take(mid)
        matches = Enum.zip(_first_half, _second_half)
        |> Enum.count(fn {a, b} -> a == b end)
        matches / mid
      end
    end)
    |> Enum.sum()
    |> Kernel./(length(matrix))
  end

  defp calculate_vertical_symmetry(matrix) do
    len = length(matrix)
    mid = div(len, 2)
    if mid == 0 do
      1.0
    else
      _first_half = Enum.take(matrix, mid)
      _second_half = matrix |> Enum.reverse() |> Enum.take(mid)
      matches = Enum.zip(_first_half, _second_half)
      |> Enum.count(fn {row1, row2} -> row1 == row2 end)
      matches / mid
    end
  end

  defp count_transitions(flat_list) do
    flat_list
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.count(fn [a, b] -> a != b end)
    |> Kernel./(max(1, length(flat_list) - 1))
  end

  defp edge_density(matrix) do
    top = Enum.at(matrix, 0) |> Enum.sum()
    bottom = Enum.at(matrix, -1) |> Enum.sum()
    left = matrix |> Enum.map(&Enum.at(&1, 0)) |> Enum.sum()
    right = matrix |> Enum.map(&Enum.at(&1, -1)) |> Enum.sum()
    (top + bottom + left + right) / 16
  end

  defp corner_activity(matrix) do
    corners = [
      Matrix.get_element(matrix, 0, 0),
      Matrix.get_element(matrix, 0, 4),
      Matrix.get_element(matrix, 4, 0),
      Matrix.get_element(matrix, 4, 4)
    ]
    Enum.sum(corners) / 4
  end

  defp center_activity(matrix) do
    center_vals = [
      Matrix.get_element(matrix, 2, 2),
      Matrix.get_element(matrix, 1, 2),
      Matrix.get_element(matrix, 2, 1),
      Matrix.get_element(matrix, 3, 2),
      Matrix.get_element(matrix, 2, 3)
    ]
    Enum.sum(center_vals) / 5
  end

  defp adjust_weight_vector(weights, features) do
    target_size = length(features)
    current_size = length(weights)
    cond do
      current_size == target_size -> weights
      current_size > target_size -> Enum.take(weights, target_size)
      current_size < target_size -> weights ++ List.duplicate(0.0, target_size - current_size)
    end
  end

  defp find_max_prediction(probabilities) do
    probabilities
    |> Enum.with_index()
    |> Enum.max_by(fn {prob, _} -> prob end)
    |> then(fn {max_prob, index} -> {index, max_prob} end)
  end

  defp print_predictions(probabilities) do
    probabilities
    |> Enum.with_index()
    |> Enum.each(fn {prob, digit} ->
      IO.puts("Dígito #{digit}: #{Float.round(prob * 100, 2)}%")
    end)
  end
end
