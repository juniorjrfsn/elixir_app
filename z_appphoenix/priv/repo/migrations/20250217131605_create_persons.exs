defmodule Appphoenix.Repo.Migrations.CreatePersons do
  use Ecto.Migration

  def change do
    create table(:persons) do
      add :name, :string
      add :description, :text

      timestamps(type: :utc_datetime)
    end
  end
end
