defmodule Appphoenix.Hellos.Hello do
  use Ecto.Schema
  import Ecto.Changeset

  schema "hellos" do
    field :total,   :float
    field :campo1,  :float
    field :campo2,  :float

    timestamps()
  end

  @doc false
  def changeset(hello, attrs) do
    hello
    |> cast(attrs, [:campo1, :campo2, :total])
    |> validate_required([:campo1, :campo2, :total])
  end
end
