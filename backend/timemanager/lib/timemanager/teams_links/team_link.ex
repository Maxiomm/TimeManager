defmodule Timemanager.TeamsLinks.TeamLink do
  use Ecto.Schema
  import Ecto.Changeset

  schema "teamlink" do
    belongs_to :team, Timemanager.Team, foreign_key: :team_id
    belongs_to :user, Timemanager.User, foreign_key: :user_id
  end

  @doc false
  def changeset(team_link, attrs) do
    team_link
    |> cast(attrs, [:team_id, :user_id])
    |> validate_required([:team_id, :user_id])
  end
end
