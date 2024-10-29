defmodule TimemanagerWeb.TeamsController do
  use TimemanagerWeb, :controller

  alias Timemanager.Team
  alias Timemanager.Team.Teams

  action_fallback TimemanagerWeb.FallbackController

  # Fonction pour assainir les données de `teams`
  defp sanitize_team_data(teams) do
    %{
      id: teams.id,
      name: Phoenix.HTML.safe_to_string(Phoenix.HTML.html_escape(teams.name)),
      admin_id: teams.admin_id
    }
  end

  def index(conn, _params) do
    teams = Team.list_teams()
    sanitized_teams = Enum.map(teams, &sanitize_team_data/1)
    render(conn, :index, teams: sanitized_teams)
  end

  def showByAdmin(conn, %{"admin" => admin_id}) do
    teams = Team.teamByAdmin(admin_id)
    sanitized_teams = Enum.map(teams, &sanitize_team_data/1)
    render(conn, "index.json", teams: sanitized_teams)
  end

  def create(conn, %{"teams" => teams_params}) do
    with {:ok, %Teams{} = teams} <- Team.create_teams(teams_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/teams/#{teams}")
      |> render(:show, teams: sanitize_team_data(teams))
    end
  end

  def show(conn, %{"id" => id}) do
    teams = Team.get_teams!(id)
    sanitized_data = sanitize_team_data(teams)
    render(conn, :show, teams: sanitized_data)
  end

  def update(conn, %{"id" => id, "teams" => teams_params}) do
    teams = Team.get_teams!(id)

    with {:ok, %Teams{} = teams} <- Team.update_teams(teams, teams_params) do
      render(conn, :show, teams: sanitize_team_data(teams))
    end
  end

  def delete(conn, %{"id" => id}) do
    teams = Team.get_teams!(id)

    with {:ok, %Teams{}} <- Team.delete_teams(teams) do
      send_resp(conn, :no_content, "")
    end
  end
end
