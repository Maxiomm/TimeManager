defmodule TimemanagerWeb.TeamLinkControllerTest do
  use TimemanagerWeb.ConnCase

  import Timemanager.TeamsLinksFixtures

  alias Timemanager.TeamsLinks.TeamLink

  @create_attrs %{

  }
  @update_attrs %{

  }
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all teamlink", %{conn: conn} do
      conn = get(conn, ~p"/api/teamlink")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create team_link" do
    test "renders team_link when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/teamlink", team_link: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/teamlink/#{id}")

      assert %{
               "id" => ^id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/teamlink", team_link: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update team_link" do
    setup [:create_team_link]

    test "renders team_link when data is valid", %{conn: conn, team_link: %TeamLink{id: id} = team_link} do
      conn = put(conn, ~p"/api/teamlink/#{team_link}", team_link: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/teamlink/#{id}")

      assert %{
               "id" => ^id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, team_link: team_link} do
      conn = put(conn, ~p"/api/teamlink/#{team_link}", team_link: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete team_link" do
    setup [:create_team_link]

    test "deletes chosen team_link", %{conn: conn, team_link: team_link} do
      conn = delete(conn, ~p"/api/teamlink/#{team_link}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/teamlink/#{team_link}")
      end
    end
  end

  defp create_team_link(_) do
    team_link = team_link_fixture()
    %{team_link: team_link}
  end
end
