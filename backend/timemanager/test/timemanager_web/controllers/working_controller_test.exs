defmodule TimemanagerWeb.WorkingControllerTest do
  use TimemanagerWeb.ConnCase

  import Timemanager.WorkingTimeFixtures

  alias Timemanager.WorkingTime.Working

  @create_attrs %{
    start: ~U[2024-10-06 13:58:00Z],
    end: ~U[2024-10-06 13:58:00Z]
  }
  @update_attrs %{
    start: ~U[2024-10-07 13:58:00Z],
    end: ~U[2024-10-07 13:58:00Z]
  }
  @invalid_attrs %{start: nil, end: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all workingtime", %{conn: conn} do
      conn = get(conn, ~p"/api/workingtime")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create working" do
    test "renders working when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/workingtime", working: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/workingtime/#{id}")

      assert %{
               "id" => ^id,
               "end" => "2024-10-06T13:58:00Z",
               "start" => "2024-10-06T13:58:00Z"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/workingtime", working: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update working" do
    setup [:create_working]

    test "renders working when data is valid", %{conn: conn, working: %Working{id: id} = working} do
      conn = put(conn, ~p"/api/workingtime/#{working}", working: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/workingtime/#{id}")

      assert %{
               "id" => ^id,
               "end" => "2024-10-07T13:58:00Z",
               "start" => "2024-10-07T13:58:00Z"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, working: working} do
      conn = put(conn, ~p"/api/workingtime/#{working}", working: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete working" do
    setup [:create_working]

    test "deletes chosen working", %{conn: conn, working: working} do
      conn = delete(conn, ~p"/api/workingtime/#{working}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/workingtime/#{working}")
      end
    end
  end

  defp create_working(_) do
    working = working_fixture()
    %{working: working}
  end
end
