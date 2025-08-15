defmodule Appphoenix.PostsserviceFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Appphoenix.Postsservice` context.
  """

  @doc """
  Generate a postservice.
  """
  def postservice_fixture(attrs \\ %{}) do
    {:ok, postservice} =
      attrs
      |> Enum.into(%{
        body: "some body",
        title: "some title"
      })
      |> Appphoenix.Postsservice.create_postservice()

    postservice
  end

  @doc """
  Generate a postservice.
  """
  def postservice_fixture(attrs \\ %{}) do
    {:ok, postservice} =
      attrs
      |> Enum.into(%{
        body: "some body",
        title: "some title"
      })
      |> Appphoenix.Postsservice.create_postservice()

    postservice
  end
end
