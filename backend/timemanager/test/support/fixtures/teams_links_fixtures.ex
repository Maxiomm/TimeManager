defmodule Timemanager.TeamsLinksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Timemanager.TeamsLinks` context.
  """

  @doc """
  Generate a team_link.
  """
  def team_link_fixture(attrs \\ %{}) do
    {:ok, team_link} =
      attrs
      |> Enum.into(%{

      })
      |> Timemanager.TeamsLinks.create_team_link()

    team_link
  end
end
