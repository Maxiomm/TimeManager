defmodule Timemanager.Team.Teams do
  use Ecto.Schema
  import Ecto.Changeset

  schema "teams" do
    field :name, :string
    belongs_to :admin, Timemanager.User, foreign_key: :admin_id

  end

  @doc false
  def changeset(teams, attrs) do
    teams
    |> cast(attrs, [:name, :admin_id])
    |> validate_required([:name, :admin_id])
  end
end
