defmodule Appphoenix.Fisica.Formula do
  use Ecto.Schema
  import Ecto.Changeset

  schema "fisica" do
    field :massa, :float
    field :espaco, :string
    field :total, :float
    field :peso, :float
    field :aceleracao, :float

    timestamps()
  end

  @doc false
  def changeset(formula, attrs) do
    formula
    |> cast(attrs, [:massa, :espaco])
    |> validate_required([:massa, :espaco])
  end
end
