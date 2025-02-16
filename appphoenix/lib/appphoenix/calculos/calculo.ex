defmodule Appphoenix.Calculos.Calculo do
  use Ecto.Schema
  import Ecto.Changeset

  schema "calculos" do
    field :total, :float
    field :campo1, :float
    field :campo2, :float

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(calculo, attrs) do
    calculo
    |> cast(attrs, [:campo1, :campo2, :total])
    |> validate_required([:campo1, :campo2, :total])
  end
end
