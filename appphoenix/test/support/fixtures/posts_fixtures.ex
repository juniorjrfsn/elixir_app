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
        body: "some body",
        title: "some title"
      })
      |> Appphoenix.Posts.create_post()

    post
  end

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

  @doc """
  Generate a post_web.
  """
  def post_web_fixture(attrs \\ %{}) do
    {:ok, post_web} =
      attrs
      |> Enum.into(%{
        title: "some title",
        body: "some body"
      })
      |> Appphoenix.Posts.create_post_web()

    post_web
  end
end
