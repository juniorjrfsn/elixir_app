defmodule Appphoenix.Postsservice.Postservice do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :title, :string
    field :body, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(postservice, attrs) do
    postservice
    |> cast(attrs, [:title, :body])
    |> validate_required([:title, :body])
  end
end
