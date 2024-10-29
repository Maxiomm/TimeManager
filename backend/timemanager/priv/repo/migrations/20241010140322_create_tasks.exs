defmodule Timemanager.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :title, :string
      add :start, :utc_datetime
      add :end, :utc_datetime
      add :category_id, references(:categories, on_delete: :delete_all)
      add :user_id, references(:users, on_delete: :delete_all)

    end

    create index(:tasks, [:category_id])
    create index(:tasks, [:user_id])


  # to prohibit the null value for username field
  execute """
          ALTER TABLE tasks
          ALTER COLUMN title SET NOT NULL,
          ALTER COLUMN start SET NOT NULL,
          ALTER COLUMN \"end"\ SET NOT NULL,
          ALTER COLUMN category_id SET NOT NULL,
          ALTER COLUMN user_id SET NOT NULL;
          """

  execute """
     ALTER TABLE tasks
     ALTER COLUMN start SET DATA TYPE TIMESTAMP WITH TIME ZONE USING start AT TIME ZONE 'UTC';
  """

  execute """
     ALTER TABLE tasks
     ALTER COLUMN \"end"\ SET DATA TYPE TIMESTAMP WITH TIME ZONE USING \"end"\ AT TIME ZONE 'UTC';
  """

    execute """
       ALTER TABLE tasks
       ADD CONSTRAINT start CHECK (start IS NOT NULL AND start AT TIME ZONE 'UTC' IS NOT NULL);
    """

  execute """
     ALTER TABLE tasks
     ADD CONSTRAINT \"end"\ CHECK (\"end"\ IS NOT NULL AND \"end"\ AT TIME ZONE 'UTC' IS NOT NULL);
  """
  end
end
