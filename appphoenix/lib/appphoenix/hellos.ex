defmodule Appphoenix.Hellos do
  @moduledoc """
  The Hellos context.
  """

  import Ecto.Query, warn: false
  alias Appphoenix.Repo

  alias Appphoenix.Hellos.Hello

  def create_hello(attrs \\ %{}) do
    %Hello{}
    |> Hello.changeset(attrs)
    |> Repo.insert()
  end

  def change_hello(%Hello{} = hello, attrs \\ %{}) do
    Hello.changeset(hello, attrs)
  end
end
