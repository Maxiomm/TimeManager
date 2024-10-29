defmodule Timemanager.Repo.Migrations.ModifyTablesV4 do
  use Ecto.Migration

  def change do
    # allows you to create the user table in the database
    create table(:users) do
      add :username, :string, null: false
      add :email, :string, null: false
      add :status, :string, null: false
      add :mdp, :string, null: false
    end

    # allows you to create the clocks table in the database
    create table(:clocks) do
      add :time, :utc_datetime, null: false
      add :status, :boolean, default: true, null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false
    end

    # allows you to create the workingtime table in the database
    create table(:workingtime) do
      add :start, :utc_datetime, null: false
      add :end, :utc_datetime
      add :isworking, :boolean, default: true, null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false
    end

    # to prohibit the null value for username field
    execute "ALTER TABLE users ALTER COLUMN username SET NOT NULL"
    execute "ALTER TABLE users ALTER COLUMN status SET NOT NULL"

    # to prohibit the empty value for username
    execute "ALTER TABLE users ADD CONSTRAINT username_not_empty CHECK (username <> '');"
    execute "ALTER TABLE users ADD CONSTRAINT mdp_not_empty CHECK (mdp <> '');"

    # Add a constraint to check the format of the field email (X@X.X)
    execute "ALTER TABLE users ADD CONSTRAINT email_must_have_at_and_dote CHECK (email ~* '^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$')"

    # Add a constraint to check if email are unique
    execute "ALTER TABLE users ADD CONSTRAINT unique_email UNIQUE (email)"

    # to prohibit the null value for time, status, user_id field
    execute """
      ALTER TABLE clocks
      ALTER COLUMN time SET NOT NULL,
      ALTER COLUMN status SET NOT NULL,
      ALTER COLUMN user_id SET NOT NULL;
    """

    execute """
       ALTER TABLE clocks
       ALTER COLUMN time SET DATA TYPE TIMESTAMP WITH TIME ZONE USING time AT TIME ZONE 'UTC';
    """

    #  to prohibit null values for start and end fields and check the field format (UTC)
    execute """
       ALTER TABLE clocks
       ADD CONSTRAINT time CHECK (time IS NOT NULL AND time AT TIME ZONE 'UTC' IS NOT NULL);
    """

    # to prohibit the null value for start, end, user_id field
    execute """
      ALTER TABLE workingtime
      ALTER COLUMN start SET NOT NULL,
      ALTER COLUMN user_id SET NOT NULL,
      ALTER COLUMN isworking SET NOT NULL;
    """

    # allows you to put the values of the start and end fields in UTC format
    execute """
       ALTER TABLE workingtime
       ALTER COLUMN start SET DATA TYPE TIMESTAMP WITH TIME ZONE USING start AT TIME ZONE 'UTC',
       ALTER COLUMN \"end\" SET DATA TYPE TIMESTAMP WITH TIME ZONE USING \"end\" AT TIME ZONE 'UTC';
    """

    #  to prohibit null values for start and end fields and check the field format (UTC)
    execute """
       ALTER TABLE workingtime
       ADD CONSTRAINT start CHECK (start IS NOT NULL AND start AT TIME ZONE 'UTC' IS NOT NULL);
    """
  end
end
