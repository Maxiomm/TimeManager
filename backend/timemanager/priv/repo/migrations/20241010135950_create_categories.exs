defmodule Timemanager.Repo.Migrations.CreateCategories do
  use Ecto.Migration

  def change do
    create table(:categories) do
      add :title, :string, null: false
      add :color, :string, null: false
    end
    execute "ALTER TABLE categories ALTER COLUMN title SET NOT NULL"
    execute "ALTER TABLE categories ALTER COLUMN color SET NOT NULL"
  end
end
