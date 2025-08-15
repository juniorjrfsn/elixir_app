defmodule Appphoenix.Repo.Migrations.CreateFisica do
  use Ecto.Migration

  def change do
    create table(:fisica) do
      add :massa, :float
      add :espaco, :string

      add :total, :float
      add :peso, :float
      add :aceleracao, :float
      # forcag
      add :massa1, :float
      add :massa2, :float
      add :distancia, :float
      add :newton, :float

      timestamps()
    end
  end
end
