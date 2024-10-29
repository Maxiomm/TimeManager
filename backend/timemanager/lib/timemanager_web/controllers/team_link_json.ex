defmodule TimemanagerWeb.TeamLinkJSON do
  alias Timemanager.TeamsLinks.TeamLink

  @doc """
  Renders a list of teamlink.
  """
  def index(%{teamlink: teamlink}) do
    %{data: for(team_link <- teamlink, do: data(team_link))}
  end

  @doc """
  Renders a single team_link.
  """
  def show(%{team_link: team_link}) do
    %{data: data(team_link)}
  end

  defp data(%Timemanager.TeamsLinks.TeamLink{} = team_link) do
    %{
      id: team_link.id,
      team_id: team_link.team_id,
      user_id: team_link.user_id
    }
  end
end
