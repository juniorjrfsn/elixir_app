defmodule Appphoenix.Repo.Migrations.CreateFisica do
  use Ecto.Migration

  def change do
    create table(:fisica) do
      add :massa, :float
      add :espaco, :string

      timestamps()
    end
  end
end
