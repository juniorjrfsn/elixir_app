defmodule Appphoenix.Pessoas.Pessoa do
  use Ecto.Schema
  import Ecto.Changeset

  schema "persons" do
    field :name, :string
    field :description, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(pessoa, attrs) do
    pessoa
    |> cast(attrs, [:name, :description])
    |> validate_required([:name, :description])
  end
end
