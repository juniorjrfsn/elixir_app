defmodule Appphoenix.FunctionsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Appphoenix.Functions` context.
  """

  @doc """
  Generate a task.
  """
  def task_fixture(attrs \\ %{}) do
    {:ok, task} =
      attrs
      |> Enum.into(%{
        description: "some description",
        title: "some title"
      })
      |> Appphoenix.Functions.create_task()

    task
  end
end
