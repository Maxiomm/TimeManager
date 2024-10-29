defmodule TimemanagerWeb.TeamLinkController do
  use TimemanagerWeb, :controller

  alias Timemanager.TeamsLinks
  alias Timemanager.TeamsLinks.TeamLink

  action_fallback TimemanagerWeb.FallbackController

  def index(conn, _params) do
    case TeamsLinks.list_teamlink() do
      nil ->
        conn
        # Make a 404 status
        |> put_status(:not_found)
          # Create a json message
        |> json(%{error: "TeamLink not found"})
      team_link  ->
        conn
        render(conn, :index, teamlink: team_link)
    end
  end

  def create(conn, %{"team_link" => team_link_params}) do
    case TeamsLinks.create_team_link(team_link_params) do
      {:ok, %TeamLink{} = team_link} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", ~p"/api/teamlink/#{team_link}")
        |> render(:show, team_link: team_link)
      {:error, changeset} ->
        # Retrieves changeset error messages and map format
        errors = Ecto.Changeset.traverse_errors(changeset, fn {msg, _opts} -> msg end)
        conn
        # Make a 400 status
        |> put_status(:bad_request)
          # Create a json message
        |> json(%{error: errors})
    end
  end

  def show(conn, %{"id" => id}) do
    case TeamsLinks.get_team_link(id) do
      nil ->
        conn
        # Make a 404 status
        |> put_status(:not_found)
          # Create a json message
        |> json(%{error: "TeamLink not found"})
      team_link  ->
        conn
        render(conn, :show, team_link: team_link)
    end
  end

  def showByUserID(conn, %{"userID" => user_id}) do
    case TeamsLinks.get_team_link_by_id_user(user_id) do
      nil ->
        conn
        # Make a 404 status
        |> put_status(:not_found)
          # Create a json message
        |> json(%{error: "TeamLink not found"})
      team_link  ->
        conn
        render(conn, :index, teamlink: team_link)
    end
  end

  def showByTeamId(conn, %{"teamID" => team_id}) do
    case TeamsLinks.get_team_link_by_id_team(team_id) do
      nil ->
        conn
        # Make a 404 status
        |> put_status(:not_found)
          # Create a json message
        |> json(%{error: "TeamLink not found"})
      team_link  ->
        conn
        render(conn, :index, teamlink: team_link)
    end
  end

  def update(conn, %{"id" => id, "team_link" => team_link_params}) do
    team_link =

    case TeamsLinks.get_team_link(id) do
      nil ->
        conn
        # Make a 404 status
        |> put_status(:not_found)
          # Create a json message
        |> json(%{error: "TeamLink not found"})

        team_link ->
          case TeamsLinks.update_team_link(team_link, team_link_params) do
              {:ok, %TeamLink{} = team_link} ->
                send_resp(conn, :ok, "Update Succefully")
              {:error, changeset} ->
                 # Retrieves changeset error messages and map format
                errors = Ecto.Changeset.traverse_errors(changeset, fn {msg, _opts} -> msg end)
                conn
                # Make a 400 status
                |> put_status(:bad_request)
                  # Create a json message
                |> json(%{error: errors})
          end
      end
  end

  def delete(conn, %{"id" => id}) do
    team_link = TeamsLinks.get_team_link(id)

    case TeamsLinks.get_team_link(id) do
      nil ->
        conn
        # Make a 404 status
        |> put_status(:not_found)
          # Create a json message
        |> json(%{error: "TeamLink not found"})

      team_link ->
        case TeamsLinks.delete_team_link(team_link) do
          {:ok, %TeamLink{} = team_link} ->
            send_resp(conn, :ok, "Delete Succefully")
          {:error, changeset} ->
            # Retrieves changeset error messages and map format
            errors = Ecto.Changeset.traverse_errors(changeset, fn {msg, _opts} -> msg end)
            conn
            # Make a 400 status
            |> put_status(:bad_request)
              # Create a json message
            |> json(%{error: errors})
        end
    end

    end
end
