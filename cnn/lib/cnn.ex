# lib/cnn.ex
defmodule Cnn do
  @moduledoc """
  CNN - Convolutional Neural Network for digit classification
  Main module that orchestrates the entire application
  """

  alias Cnn.{Matrix, Neural, Utils}

  @doc """
  Main function to run the CNN application
  """
  def main do
    IO.puts("=== APLICATIVO CNN - CLASSIFICAÇÃO DE DÍGITOS ===\n")

    # Initialize random seed
    :rand.seed(:exsplus, {1, 2, 3})

    # Create digit matrices
    matrices = Matrix.create_digit_matrices()
    IO.puts("Matrizes de treinamento criadas (10 dígitos)")
    IO.puts("Cada matriz representa um dígito de 0 a 9 em formato 5x5\n")

    # Create and train network
    network = Neural.create_network()
    trained_network = Neural.train_network(network, matrices)

    # Show network weights
    Neural.print_network_weights(trained_network)

    # Test with digit 5 using pattern matching
    test_matrix = matrices |> Enum.at(5) |> Utils.integer_to_float_matrix()
    Neural.test_network_patterns(trained_network, test_matrix, 5, matrices)

    # Test with digit 8 using pattern matching
    test_matrix2 = matrices |> Enum.at(8) |> Utils.integer_to_float_matrix()
    Neural.test_network_patterns(trained_network, test_matrix2, 8, matrices)

    # Test with noise
    noisy_matrix = add_noise(test_matrix, 0.1)
    IO.puts("=== TESTE COM RUÍDO ===")
    Neural.test_network_patterns(trained_network, noisy_matrix, 5, matrices)

    IO.puts("=== APLICATIVO CNN FINALIZADO ===")
  end

  @doc """
  Runs comprehensive tests on all digits
  """
  def run_tests do
    IO.puts("=== BATERIA DE TESTES DA CNN ===\n")

    :rand.seed(:exsplus, {1, 2, 3})
    network = Neural.create_network()
    matrices = Matrix.create_digit_matrices()
    trained_network = Neural.train_network(network, matrices)

    # Test all digits with pattern matching
    results = test_all_digits_patterns(trained_network, matrices)
    print_test_statistics(results)

    # Benchmark
    benchmark_network(trained_network, matrices)
  end

  @doc """
  Test a single digit with optional noise using pattern matching
  """
  def test_digit(digit, noise_level \\ 0.0) when digit >= 0 and digit <= 9 do
    :rand.seed(:exsplus, {1, 2, 3})
    network = Neural.create_network()
    matrices = Matrix.create_digit_matrices()
    trained_network = Neural.train_network(network, matrices)

    test_matrix = matrices |> Enum.at(digit) |> Utils.integer_to_float_matrix()

    final_matrix = if noise_level > 0 do
      IO.puts("=== TESTE COM RUÍDO (#{trunc(noise_level * 100)}%) ===")
      add_noise(test_matrix, noise_level)
    else
      test_matrix
    end

    # Use pattern matching approach for better accuracy
    Neural.test_network_patterns(trained_network, final_matrix, digit, matrices)
  end

  # Private functions

  defp add_noise(matrix, noise_level) do
    for row <- matrix do
      for x <- row do
        if :rand.uniform() < noise_level do
          if x > 0.5, do: 0.0, else: 1.0
        else
          x
        end
      end
    end
  end

  defp test_all_digits_patterns(network, matrices) do
    IO.puts("=== TESTE COMPLETO COM RECONHECIMENTO DE PADRÕES ===")

    results = for digit <- 0..9 do
      test_matrix = matrices |> Enum.at(digit) |> Utils.integer_to_float_matrix()
      {predicted_digit, confidence} = Neural.test_network_patterns(network, test_matrix, digit, matrices)

      success = predicted_digit == digit
      status = if success, do: "✅", else: "❌"
      IO.puts("Dígito #{digit}: #{status} (confiança: #{Float.round(confidence * 100, 1)}%)")

      {digit, predicted_digit, confidence, success}
    end

    IO.puts("")
    results
  end

  defp print_test_statistics(results) do
    IO.puts("=== ESTATÍSTICAS DOS TESTES ===")

    total_tests = length(results)
    successful_tests = results |> Enum.count(fn {_, _, _, success} -> success end)
    accuracy = (successful_tests / total_tests) * 100

    # Fixed division operation with proper parentheses
    avg_confidence = (results |> Enum.map(fn {_, _, c, _} -> c end) |> Enum.sum()) / total_tests

    success_confidences = results |> Enum.filter(fn {_, _, _, success} -> success end) |> Enum.map(fn {_, _, c, _} -> c end)
    success_confidence = if length(success_confidences) > 0, do: Enum.sum(success_confidences) / length(success_confidences), else: 0

    IO.puts("Total de testes: #{total_tests}")
    IO.puts("Acertos: #{successful_tests}/#{total_tests} (#{Float.round(accuracy, 1)}%)")
    IO.puts("Confiança média: #{Float.round(avg_confidence * 100, 1)}%")
    IO.puts("Confiança em acertos: #{Float.round(success_confidence * 100, 1)}%")

    # Show errors
    errors = results |> Enum.filter(fn {_, _, _, success} -> not success end) |> Enum.map(fn {expected, predicted, _, _} -> {expected, predicted} end)

    if length(errors) == 0 do
      IO.puts("Nenhum erro encontrado! 🎉")
    else
      IO.puts("Erros encontrados:")
      for {expected, predicted} <- errors do
        IO.puts("  Esperado: #{expected}, Predito: #{predicted}")
      end
    end

    IO.puts("")
  end

  defp benchmark_network(network, matrices) do
    IO.puts("=== BENCHMARK DE PERFORMANCE ===")

    # Measure training time
    {train_time, trained_network} = :timer.tc(fn -> Neural.train_network(network, matrices) end)

    # Measure inference time with pattern matching
    test_matrix = matrices |> Enum.at(0) |> Utils.integer_to_float_matrix()
    {infer_time, _} = :timer.tc(fn -> Neural.predict_with_patterns(trained_network, test_matrix, matrices) end)

    # Also measure regular neural network inference
    {nn_infer_time, _} = :timer.tc(fn -> Neural.predict(trained_network, test_matrix) end)

    IO.puts("Tempo de treinamento: #{Float.round(train_time / 1000, 2)} ms")
    IO.puts("Tempo de inferência (padrões): #{Float.round(infer_time / 1000, 2)} ms")
    IO.puts("Tempo de inferência (rede neural): #{Float.round(nn_infer_time / 1000, 2)} ms")
    IO.puts("")
  end
end
