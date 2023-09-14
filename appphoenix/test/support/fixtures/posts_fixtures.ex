defmodule Appphoenix.PostsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Appphoenix.Posts` context.
  """

  @doc """
  Generate a post.
  """
  def post_fixture(attrs \\ %{}) do
    {:ok, post} =
      attrs
      |> Enum.into(%{
        title: "some title",
        body: "some body"
      })
      |> Appphoenix.Posts.create_post()

    post
  end
end
