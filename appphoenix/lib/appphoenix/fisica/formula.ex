defmodule Appphoenix.Fisica.Formula do
  use Ecto.Schema
  import Ecto.Changeset

  schema "fisica" do
    field :massa,       :float
    field :espaco,      :string
    field :total,       :float
    field :peso,        :float
    field :aceleracao,  :float

    # fisica_form_forcag.html.heex
    field :massa1,    :float
    field :massa2,    :float
    field :distancia, :float
    field :newton,    :float

    timestamps()
  end

  @doc false
  def changeset(formula, attrs) do
    formula
    |> cast(attrs, [:massa, :espaco, :total, :peso, :aceleracao, :massa1, :massa2, :distancia, :newton ])
    |> validate_required([:massa, :espaco])
  end
end
