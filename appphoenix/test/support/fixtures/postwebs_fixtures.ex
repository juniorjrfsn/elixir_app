defmodule Appphoenix.PostwebsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Appphoenix.Postwebs` context.
  """

  @doc """
  Generate a postweb.
  """
  def postweb_fixture(attrs \\ %{}) do
    {:ok, postweb} =
      attrs
      |> Enum.into(%{
        title: "some title",
        body: "some body"
      })
      |> Appphoenix.Postwebs.create_postweb()

    postweb
  end
end
