defmodule TimemanagerWeb.TasksControllerTest do
  use TimemanagerWeb.ConnCase

  import Timemanager.TaskFixtures

  alias Timemanager.Task.Tasks

  @create_attrs %{
    start: ~U[2024-10-09 14:03:00Z],
    title: "some title",
    end: ~U[2024-10-09 14:03:00Z]
  }
  @update_attrs %{
    start: ~U[2024-10-10 14:03:00Z],
    title: "some updated title",
    end: ~U[2024-10-10 14:03:00Z]
  }
  @invalid_attrs %{start: nil, title: nil, end: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all tasks", %{conn: conn} do
      conn = get(conn, ~p"/api/tasks")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create tasks" do
    test "renders tasks when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/tasks", tasks: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/tasks/#{id}")

      assert %{
               "id" => ^id,
               "end" => "2024-10-09T14:03:00Z",
               "start" => "2024-10-09T14:03:00Z",
               "title" => "some title"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/tasks", tasks: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update tasks" do
    setup [:create_tasks]

    test "renders tasks when data is valid", %{conn: conn, tasks: %Tasks{id: id} = tasks} do
      conn = put(conn, ~p"/api/tasks/#{tasks}", tasks: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/tasks/#{id}")

      assert %{
               "id" => ^id,
               "end" => "2024-10-10T14:03:00Z",
               "start" => "2024-10-10T14:03:00Z",
               "title" => "some updated title"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, tasks: tasks} do
      conn = put(conn, ~p"/api/tasks/#{tasks}", tasks: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete tasks" do
    setup [:create_tasks]

    test "deletes chosen tasks", %{conn: conn, tasks: tasks} do
      conn = delete(conn, ~p"/api/tasks/#{tasks}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/tasks/#{tasks}")
      end
    end
  end

  defp create_tasks(_) do
    tasks = tasks_fixture()
    %{tasks: tasks}
  end
end
