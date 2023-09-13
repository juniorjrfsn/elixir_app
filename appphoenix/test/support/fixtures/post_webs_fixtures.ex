defmodule Appphoenix.PostWebsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Appphoenix.PostWebs` context.
  """

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
      |> Appphoenix.PostWebs.create_post_web()

    post_web
  end
end
