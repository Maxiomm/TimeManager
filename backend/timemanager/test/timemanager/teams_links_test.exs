defmodule Timemanager.TeamsLinksTest do
  use Timemanager.DataCase

  alias Timemanager.TeamsLinks

  describe "teamlink" do
    alias Timemanager.TeamsLinks.TeamLink

    import Timemanager.TeamsLinksFixtures

    @invalid_attrs %{}

    test "list_teamlink/0 returns all teamlink" do
      team_link = team_link_fixture()
      assert TeamsLinks.list_teamlink() == [team_link]
    end

    test "get_team_link!/1 returns the team_link with given id" do
      team_link = team_link_fixture()
      assert TeamsLinks.get_team_link!(team_link.id) == team_link
    end

    test "create_team_link/1 with valid data creates a team_link" do
      valid_attrs = %{}

      assert {:ok, %TeamLink{} = team_link} = TeamsLinks.create_team_link(valid_attrs)
    end

    test "create_team_link/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = TeamsLinks.create_team_link(@invalid_attrs)
    end

    test "update_team_link/2 with valid data updates the team_link" do
      team_link = team_link_fixture()
      update_attrs = %{}

      assert {:ok, %TeamLink{} = team_link} = TeamsLinks.update_team_link(team_link, update_attrs)
    end

    test "update_team_link/2 with invalid data returns error changeset" do
      team_link = team_link_fixture()
      assert {:error, %Ecto.Changeset{}} = TeamsLinks.update_team_link(team_link, @invalid_attrs)
      assert team_link == TeamsLinks.get_team_link!(team_link.id)
    end

    test "delete_team_link/1 deletes the team_link" do
      team_link = team_link_fixture()
      assert {:ok, %TeamLink{}} = TeamsLinks.delete_team_link(team_link)
      assert_raise Ecto.NoResultsError, fn -> TeamsLinks.get_team_link!(team_link.id) end
    end

    test "change_team_link/1 returns a team_link changeset" do
      team_link = team_link_fixture()
      assert %Ecto.Changeset{} = TeamsLinks.change_team_link(team_link)
    end
  end
end
