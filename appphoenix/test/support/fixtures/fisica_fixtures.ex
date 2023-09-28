defmodule Appphoenix.FisicaFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Appphoenix.Fisica` context.
  """

  @doc """
  Generate a formula.
  """
  def formula_fixture(attrs \\ %{}) do
    {:ok, formula} =
      attrs
      |> Enum.into(%{
        massa: 120.5,
        espaco: "some espaco"
      })
      |> Appphoenix.Fisica.create_formula()

    formula
  end
end
