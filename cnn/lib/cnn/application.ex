# lib/cnn/application.ex
defmodule Cnn.Application do
  @moduledoc """
  OTP Application for the CNN project
  """

  use Application

  @impl true
  def start(_type, _args) do
    IO.puts("Iniciando aplicativo CNN...")

    # Initialize random seed
    :rand.seed(:exsplus, {1, 2, 3})

    # Create digit matrices and print them
    matrices = Cnn.Matrix.create_digit_matrices()
    Cnn.Matrix.print_matrices(matrices)

    # Define children processes
    children = [
      # Add supervised processes here if needed
      # For this example, we'll use a simple supervisor with no children
    ]

    # Supervisor options
    opts = [strategy: :one_for_one, name: Cnn.Supervisor]

    # Start the supervisor
    result = Supervisor.start_link(children, opts)

    IO.puts("Aplicativo CNN iniciado com sucesso!")
    result
  end

  @impl true
  def stop(_state) do
    IO.puts("Aplicativo CNN finalizado.")
    :ok
  end

  @doc """
  Runs the CNN application as a standalone script
  """
  def run_script do
    IO.puts("=== EXECUTANDO CNN COMO SCRIPT ===\n")

    # Run the main application
    Cnn.main()

    # Keep the application running briefly to see output
    Process.sleep(1000)

    # Exit gracefully
    System.halt(0)
  end

  @doc """
  Interactive mode for testing different configurations
  """
  def interactive_mode do
    IO.puts("=== MODO INTERATIVO CNN ===")
    IO.puts("Digite 'help' para ver os comandos disponíveis")
    IO.puts("Digite 'quit' para sair\n")

    interactive_loop()
  end

  defp interactive_loop do
    input = IO.gets("CNN> ") |> String.trim()

    case input do
      "quit" ->
        IO.puts("Saindo do modo interativo...")

      "help" ->
        print_help()
        interactive_loop()

      "test_all" ->
        Cnn.run_tests()
        interactive_loop()

      "main" ->
        Cnn.main()
        interactive_loop()

      "matrices" ->
        matrices = Cnn.Matrix.create_digit_matrices()
        Cnn.Matrix.print_matrices(matrices)
        interactive_loop()

      command when command in ["test_0", "test_1", "test_2", "test_3", "test_4", "test_5", "test_6", "test_7", "test_8", "test_9"] ->
        digit = String.last(command) |> String.to_integer()
        Cnn.test_digit(digit)
        interactive_loop()

      "noise_test" ->
        IO.puts("Testando dígito 5 com 20% de ruído:")
        Cnn.test_digit(5, 0.2)
        interactive_loop()

      "benchmark" ->
        run_benchmark()
        interactive_loop()

      "stats" ->
        show_network_stats()
        interactive_loop()

      _ ->
        IO.puts("Comando não reconhecido. Digite 'help' para ver os comandos disponíveis.")
        interactive_loop()
    end
  end

  defp print_help do
    IO.puts("Comandos disponíveis:")
    IO.puts("  help        - Mostra esta ajuda")
    IO.puts("  main        - Executa o programa principal")
    IO.puts("  test_all    - Executa todos os testes")
    IO.puts("  test_N      - Testa o dígito N (0-9)")
    IO.puts("  matrices    - Mostra todas as matrizes de dígitos")
    IO.puts("  noise_test  - Testa com ruído")
    IO.puts("  benchmark   - Executa benchmark de performance")
    IO.puts("  stats       - Mostra estatísticas da rede")
    IO.puts("  quit        - Sair")
    IO.puts("")
  end

  defp run_benchmark do
    IO.puts("=== BENCHMARK DETALHADO ===")

    # Test multiple runs
    times = for _ <- 1..5 do
      :rand.seed(:exsplus, {1, 2, 3})
      network = Cnn.Neural.create_network()
      matrices = Cnn.Matrix.create_digit_matrices()

      {train_time, trained_network} = :timer.tc(fn ->
        Cnn.Neural.train_network(network, matrices)
      end)

      test_matrix = matrices |> Enum.at(0) |> Cnn.Utils.integer_to_float_matrix()
      {infer_time, _} = :timer.tc(fn ->
        Cnn.Neural.predict(trained_network, test_matrix)
      end)

      {train_time / 1000, infer_time / 1000}
    end

    train_times = Enum.map(times, fn {t, _} -> t end)
    infer_times = Enum.map(times, fn {_, i} -> i end)

    avg_train = Enum.sum(train_times) / length(train_times)
    avg_infer = Enum.sum(infer_times) / length(infer_times)

    IO.puts("Resultados de 5 execuções:")
    IO.puts("Tempo médio de treinamento: #{Float.round(avg_train, 2)} ms")
    IO.puts("Tempo médio de inferência: #{Float.round(avg_infer, 2)} ms")
    IO.puts("Tempo mínimo de inferência: #{Float.round(Enum.min(infer_times), 2)} ms")
    IO.puts("Tempo máximo de inferência: #{Float.round(Enum.max(infer_times), 2)} ms")
    IO.puts("")
  end

  defp show_network_stats do
    IO.puts("=== ESTATÍSTICAS DA ARQUITETURA ===")

    network = Cnn.Neural.create_network()

    # Count parameters
    conv1_params = length(network.conv1.filters) * 3 * 3 + length(network.conv1.bias)
    conv2_params = length(network.conv2.filters) * 3 * 3 + length(network.conv2.bias)
    fc1_params = network.fc1.input_size * network.fc1.output_size + network.fc1.output_size
    fc2_params = network.fc2.input_size * network.fc2.output_size + network.fc2.output_size

    total_params = conv1_params + conv2_params + fc1_params + fc2_params

    IO.puts("Parâmetros por camada:")
    IO.puts("  Conv1: #{conv1_params} parâmetros")
    IO.puts("  Conv2: #{conv2_params} parâmetros")
    IO.puts("  FC1: #{fc1_params} parâmetros")
    IO.puts("  FC2: #{fc2_params} parâmetros")
    IO.puts("  Total: #{total_params} parâmetros")
    IO.puts("")

    IO.puts("Arquitetura da rede:")
    IO.puts("  Entrada: 5x5 (25 pixels)")
    IO.puts("  Conv1: 4 filtros 3x3 -> 4 mapas 3x3")
    IO.puts("  Pool1: Max pooling 2x2 -> 4 mapas menores")
    IO.puts("  Flatten: -> vetor de características")
    IO.puts("  FC1: -> 16 neurônios")
    IO.puts("  FC2: -> 10 neurônios (saída)")
    IO.puts("  Ativação: ReLU + Softmax final")
    IO.puts("")
  end
end
