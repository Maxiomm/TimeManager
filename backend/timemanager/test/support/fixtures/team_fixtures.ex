defmodule Timemanager.TeamFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Timemanager.Team` context.
  """

  @doc """
  Generate a teams.
  """
  def teams_fixture(attrs \\ %{}) do
    {:ok, teams} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> Timemanager.Team.create_teams()

    teams
  end
end
