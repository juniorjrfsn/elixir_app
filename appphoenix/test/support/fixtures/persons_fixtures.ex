defmodule Appphoenix.PersonsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Appphoenix.Persons` context.
  """

  @doc """
  Generate a person.
  """
  def person_fixture(attrs \\ %{}) do
    {:ok, person} =
      attrs
      |> Enum.into(%{
        description: "some description",
        name: "some name"
      })
      |> Appphoenix.Persons.create_person()

    person
  end

  @doc """
  Generate a person.
  """
  def person_fixture(attrs \\ %{}) do
    {:ok, person} =
      attrs
      |> Enum.into(%{
        name: "some name",
        description: "some description"
      })
      |> Appphoenix.Persons.create_person()

    person
  end
end
