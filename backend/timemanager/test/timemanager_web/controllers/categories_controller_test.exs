defmodule TimemanagerWeb.CategoriesControllerTest do
  use TimemanagerWeb.ConnCase

  import Timemanager.CategorieFixtures

  alias Timemanager.Categorie.Categories

  @create_attrs %{
    title: "some title"
  }
  @update_attrs %{
    title: "some updated title"
  }
  @invalid_attrs %{title: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all categories", %{conn: conn} do
      conn = get(conn, ~p"/api/categories")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create categories" do
    test "renders categories when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/categories", categories: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/categories/#{id}")

      assert %{
               "id" => ^id,
               "title" => "some title"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/categories", categories: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update categories" do
    setup [:create_categories]

    test "renders categories when data is valid", %{conn: conn, categories: %Categories{id: id} = categories} do
      conn = put(conn, ~p"/api/categories/#{categories}", categories: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/categories/#{id}")

      assert %{
               "id" => ^id,
               "title" => "some updated title"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, categories: categories} do
      conn = put(conn, ~p"/api/categories/#{categories}", categories: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete categories" do
    setup [:create_categories]

    test "deletes chosen categories", %{conn: conn, categories: categories} do
      conn = delete(conn, ~p"/api/categories/#{categories}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/categories/#{categories}")
      end
    end
  end

  defp create_categories(_) do
    categories = categories_fixture()
    %{categories: categories}
  end
end
