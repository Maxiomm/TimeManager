defmodule TimemanagerWeb.TeamsJSON do
  alias Timemanager.Team.Teams

  @doc """
  Renders a list of teams.
  """
  def index(%{teams: teams}) do
    %{data: for(teams <- teams, do: data(teams))}
  end

  @doc """
  Renders a single teams.
  """
  def show(%{teams: teams}) do
    %{data: data(teams)}
  end

  defp data(%Teams{} = teams) do
    %{
      id: teams.id,
      name: teams.name
    }
  end

  defp data(%Teams{} = teams) do
    %{
      id: teams.id,
      name: teams.name
    }
  end

  # Ajout d'une clause pour gérer les maps
  defp data(%{id: id, name: name, admin_id: admin_id}) do
    %{
      id: id,
      name: name,
      admin_id: admin_id
    }
  end
end
