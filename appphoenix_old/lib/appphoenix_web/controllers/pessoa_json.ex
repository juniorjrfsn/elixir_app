defmodule AppphoenixWeb.PessoaJSON do
  alias Appphoenix.Pessoas.Pessoa

  @doc """
  Renders a list of persons.
  """
  def index(%{persons: persons}) do
    %{data: for(pessoa <- persons, do: data(pessoa))}
  end

  @doc """
  Renders a single pessoa.
  """
  def show(%{pessoa: pessoa}) do
    %{data: data(pessoa)}
  end

  defp data(%Pessoa{} = pessoa) do
    %{
      id: pessoa.id,
      name: pessoa.name,
      description: pessoa.description
    }
  end
end
