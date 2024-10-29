defmodule Timemanager.Repo.Migrations.CreateTeamlink do
  use Ecto.Migration

  def change do
    create table(:teamlink) do
      add :team_id, references(:teams, on_delete: :delete_all)
      add :user_id, references(:users, on_delete: :delete_all)
    end

    create index(:teamlink, [:team_id])
    create index(:teamlink, [:user_id])
  end
end
