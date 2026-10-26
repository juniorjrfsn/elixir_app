
defmodule NeuronioTreinavel do
  # Exemplos supervisionados: {entrada, saida_esperada}
  @dados_treinamento [
    {0.00, 1},
    {0.10, 1},
    {0.20, 1},
    {0.32, 1},
    {0.33, 0},
    {0.40, 0},
    {0.50, 0},
    {0.60, 0},
    {0.66, 0},
    {0.67, 1},
    {0.80, 1},
    {0.90, 1},
    {1.00, 1}
  ]

  # Treina os dois limites do neurônio.
  def treinar do
    IO.puts("\n=== TREINAMENTO ===")

    candidatos =
      for inferior <- 0..100,
          superior <- inferior..100 do
        {inferior / 100, superior / 100}
      end

    {erros, inferior, superior} =
      Enum.reduce(candidatos, nil, fn {inf, sup}, melhor ->
        erros_atual =
          Enum.count(@dados_treinamento, fn {x, esperado} ->
            inferir_com_limites(x, inf, sup) != esperado
          end)

        case melhor do
          nil ->
            {erros_atual, inf, sup}

          {melhor_erro, _, _} when erros_atual < melhor_erro ->
            {erros_atual, inf, sup}

          _ ->
            melhor
        end
      end)

    modelo = %{
      limite_inferior: inferior,
      limite_superior: superior,
      erros: erros
    }

    IO.puts("Limite inferior aprendido: #{inferior}")
    IO.puts("Limite superior aprendido: #{superior}")
    IO.puts("Erros de treinamento: #{erros}")

    modelo
  end

  # Função de ativação binária.
  defp inferir_com_limites(x, inferior, superior) do
    if x < inferior or x > superior do
      1
    else
      0
    end
  end

  # Inferência utilizando os parâmetros aprendidos.
  def inferir(x, modelo) do
    inferir_com_limites(
      x,
      modelo.limite_inferior,
      modelo.limite_superior
    )
  end

  # Demonstração completa.
  def executar do
    modelo = treinar()

    IO.puts("\n=== INFERÊNCIA ===")

    novas_entradas = [
      0.15,
      0.32,
      0.33,
      0.45,
      0.66,
      0.67,
      0.85
    ]

    Enum.each(novas_entradas, fn x ->
      resultado = inferir(x, modelo)

      IO.puts(
        "Entrada: #{x} -> Saída: #{resultado}"
      )
    end)
  end
end

NeuronioTreinavel.executar()


# elixir neuronio_treinavel.exs
#
