defmodule Cnn.MixProject do
  use Mix.Project

  def project do
    [
      app: :cnn,
      version: "0.1.0",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      escript: escript()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {Cnn.Application, []}
    ]
  end

  # Configura o escript para execução standalone
  defp escript do
    [
      main_module: Cnn.CLI
    ]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.31", only: :dev, runtime: false}
    ]
  end
end

# CLI module for escript execution
defmodule Cnn.CLI do
  @moduledoc """
  Command Line Interface for the CNN application
  """

  def main(args) do
    case args do
      [] ->
        Cnn.Application.run_script()

      ["interactive"] ->
        Cnn.Application.interactive_mode()

      ["test"] ->
        Cnn.run_tests()

      ["main"] ->
        Cnn.main()

      ["help"] ->
        print_usage()

      ["test", digit] when digit in ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"] ->
        digit_int = String.to_integer(digit)
        Cnn.test_digit(digit_int)

      ["test", digit, noise] when digit in ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"] ->
        digit_int = String.to_integer(digit)
        noise_float = String.to_float(noise)
        Cnn.test_digit(digit_int, noise_float)

      _ ->
        IO.puts("Argumentos inválidos.")
        print_usage()
    end
  end

  defp print_usage do
    IO.puts("""
    CNN - Convolutional Neural Network para Classificação de Dígitos

    Uso:
      mix escript.build && ./cnn              # Executa programa principal
      mix escript.build && ./cnn interactive  # Modo interativo
      mix escript.build && ./cnn test         # Executa todos os testes
      mix escript.build && ./cnn main         # Executa programa principal
      mix escript.build && ./cnn test N       # Testa dígito N (0-9)
      mix escript.build && ./cnn test N 0.2   # Testa dígito N com 20% de ruído
      mix escript.build && ./cnn help         # Mostra esta ajuda

    Exemplos:
      mix escript.build && ./cnn
      mix escript.build && ./cnn test 5
      mix escript.build && ./cnn test 3 0.1
      mix escript.build && ./cnn interactive

    Ou execute diretamente com mix:
      mix run -e "Cnn.main()"
      mix run -e "Cnn.run_tests()"
      mix run -e "Cnn.test_digit(5, 0.1)"
    """)
  end
end
