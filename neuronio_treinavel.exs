defmodule NeuronioTreinavel do
  @moduledoc """
  Detector simples de anomalias baseado em uma única fonte numérica.

  Saída:
    0 = valor dentro da faixa considerada normal
    1 = valor fora da faixa considerada normal

  Observação:
  Este exemplo aprende limites a partir de exemplos rotulados.
  Ele é um sinalizador por faixa, não uma rede neural tradicional.
  """

  # Exemplos supervisionados: {valor_normalizado, classe_esperada}
  # 0 = normal; 1 = anomalia.
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

  @passo 0.01

  # ---------------------------------------------------------------------------
  # TREINAMENTO
  # ---------------------------------------------------------------------------

  def treinar do
    IO.puts("\n===================================================")
    IO.puts("                 INÍCIO DO TREINAMENTO")
    IO.puts("===================================================")
    IO.puts("[TREINO 1/5] Carregando exemplos supervisionados...")
    IO.puts("Cada exemplo contém {valor, classe_esperada}.")
    IO.puts("Classe 0 = normal | Classe 1 = anomalia")
    IO.inspect(@dados_treinamento, label: "[TREINO] Dados carregados")

    IO.puts("\n[TREINO 2/5] Gerando combinações de limites candidatos...")
    candidatos =
      for inferior <- 0..100,
          superior <- inferior..100 do
        {inferior * @passo, superior * @passo}
      end

    IO.puts("[TREINO] Quantidade de pares de limites testados: #{length(candidatos)}")
    IO.puts("[TREINO 3/5] Avaliando cada par e contando classificações incorretas...")

    {erros, inferior, superior, avaliados} =
      Enum.reduce(candidatos, {nil, nil, nil, 0}, fn {inf, sup},
                                                     {melhor_erro, melhor_inf, melhor_sup, qtd} ->
        erros_atual =
          Enum.count(@dados_treinamento, fn {x, esperado} ->
            inferir_com_limites(x, inf, sup) != esperado
          end)

        novo_melhor =
          cond do
            is_nil(melhor_erro) ->
              {erros_atual, inf, sup, qtd + 1}

            erros_atual < melhor_erro ->
              {erros_atual, inf, sup, qtd + 1}

            true ->
              {melhor_erro, melhor_inf, melhor_sup, qtd + 1}
          end

        novo_melhor
      end)

    IO.puts("[TREINO] Pares avaliados: #{avaliados}")
    IO.puts("[TREINO 4/5] Melhor faixa encontrada:")
    IO.puts("  Limite inferior: #{formatar(inferior)}")
    IO.puts("  Limite superior: #{formatar(superior)}")
    IO.puts("  Erros nos exemplos de treinamento: #{erros} de #{length(@dados_treinamento)}")

    modelo = %{
      limite_inferior: inferior,
      limite_superior: superior,
      erros: erros,
      total_exemplos: length(@dados_treinamento)
    }

    IO.puts("[TREINO 5/5] Treinamento concluído. Modelo preparado para inferência.")
    IO.puts("[TREINO] Modelo resultante:")
    IO.inspect(modelo, label: "  Parâmetros")

    modelo
  end

  # ---------------------------------------------------------------------------
  # INFERÊNCIA
  # ---------------------------------------------------------------------------

  def inferir(valor, modelo) when is_number(valor) do
    inferior = modelo.limite_inferior
    superior = modelo.limite_superior

    IO.puts("\n---------------------------------------------------")
    IO.puts("[INFERÊNCIA] Recebendo nova medição: #{formatar(valor)}")
    IO.puts("[INFERÊNCIA] Faixa considerada normal: #{formatar(inferior)} até #{formatar(superior)}")

    cond do
      valor < inferior ->
        IO.puts("[INFERÊNCIA] Comparação: #{formatar(valor)} < #{formatar(inferior)}")
        IO.puts("[INFERÊNCIA] Resultado: ANOMALIA (classe 1) — abaixo do limite inferior.")
        1

      valor > superior ->
        IO.puts("[INFERÊNCIA] Comparação: #{formatar(valor)} > #{formatar(superior)}")
        IO.puts("[INFERÊNCIA] Resultado: ANOMALIA (classe 1) — acima do limite superior.")
        1

      true ->
        IO.puts("[INFERÊNCIA] Comparação: valor dentro dos limites.")
        IO.puts("[INFERÊNCIA] Resultado: NORMAL (classe 0).")
        0
    end
  end

  def inferir(valor, _modelo) do
    IO.puts("[ERRO] A medição deve ser numérica; recebido: #{inspect(valor)}")
    {:erro, :valor_nao_numerico}
  end

  # Função de classificação usando os limites candidatos.
  defp inferir_com_limites(valor, inferior, superior) do
    if valor < inferior or valor > superior, do: 1, else: 0
  end

  defp formatar(valor) when is_float(valor), do: :erlang.float_to_binary(valor, decimals: 2)
  defp formatar(valor), do: to_string(valor)

  # ---------------------------------------------------------------------------
  # DEMONSTRAÇÃO
  # ---------------------------------------------------------------------------

  def executar do
    modelo = treinar()

    IO.puts("\n===================================================")
    IO.puts("              INÍCIO DA INFERÊNCIA")
    IO.puts("===================================================")
    IO.puts("[INFERÊNCIA] Testando medições de demonstração.")
    IO.puts("[INFERÊNCIA] Em dados reais, substitua estes valores por medições")
    IO.puts("[INFERÊNCIA] provenientes do seu único instrumento ou fonte de dados.")

    novas_entradas = [0.15, 0.32, 0.33, 0.45, 0.66, 0.67, 0.85]

    Enum.each(novas_entradas, fn valor ->
      resultado = inferir(valor, modelo)
      IO.puts("[INFERÊNCIA] Sinal final: #{if resultado == 1, do: "ALERTA", else: "SEM ALERTA"}")
    end)

    IO.puts("\n===================================================")
    IO.puts("                 FIM DA EXECUÇÃO")
    IO.puts("===================================================")
  end
end

NeuronioTreinavel.executar()


# elixir neuronio_treinavel.exs
#
