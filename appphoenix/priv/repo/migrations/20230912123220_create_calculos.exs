defmodule Appphoenix.Repo.Migrations.CreateCalculos do
  use Ecto.Migration

  def change do
    create table(:calculos) do
      add :campo1, :float
      add :campo2, :float
      add :total, :float

      timestamps()
    end
  end
end
