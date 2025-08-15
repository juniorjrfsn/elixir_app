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
        description: "some description",
        name: "some name"
      })
      |> Appphoenix.Pessoas.create_pessoa()

    pessoa
  end

  @doc """
  Generate a pessoa.
  """
  def pessoa_fixture(attrs \\ %{}) do
    {:ok, pessoa} =
      attrs
      |> Enum.into(%{
        description: "some description",
        name: "some name"
      })
      |> Appphoenix.Pessoas.create_pessoa()

    pessoa
  end
end
