defmodule Appphoenix.CalculosFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Appphoenix.Calculos` context.
  """

  @doc """
  Generate a calculo.
  """
  def calculo_fixture(attrs \\ %{}) do
    {:ok, calculo} =
      attrs
      |> Enum.into(%{
        total: 120.5,
        campo1: 120.5,
        campo2: 120.5
      })
      |> Appphoenix.Calculos.create_calculo()

    calculo
  end
end
