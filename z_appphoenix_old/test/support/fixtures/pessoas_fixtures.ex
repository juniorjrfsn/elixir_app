defmodule Appphoenix.PessoasFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Appphoenix.Pessoas` context.
  """

  @doc """
  Generate a pessoa.
  """
  def pessoa_fixture(attrs \\ %{}) do
    {:ok, pessoa} =
      attrs
      |> Enum.into(%{
        name: "some name",
        description: "some description"
      })
      |> Appphoenix.Pessoas.create_pessoa()

    pessoa
  end
end
