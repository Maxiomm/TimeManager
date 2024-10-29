defmodule Timemanager.Repo.Migrations.CreateTeams do
  use Ecto.Migration

  def change do
    create table(:teams) do
      add :name, :string
      add :admin_id, references(:users, on_delete: :delete_all)
    end

    create index(:teams, [:admin_id])

    execute """
    ALTER TABLE teams
    ALTER COLUMN name SET NOT NULL,
    ALTER COLUMN admin_id SET NOT NULL;
    """
  end
end
