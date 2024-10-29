defmodule Timemanager.CategorieTest do
  use Timemanager.DataCase

  alias Timemanager.Categorie

  describe "categories" do
    alias Timemanager.Categorie.Categories

    import Timemanager.CategorieFixtures

    @invalid_attrs %{title: nil}

    test "list_categories/0 returns all categories" do
      categories = categories_fixture()
      assert Categorie.list_categories() == [categories]
    end

    test "get_categories!/1 returns the categories with given id" do
      categories = categories_fixture()
      assert Categorie.get_categories!(categories.id) == categories
    end

    test "create_categories/1 with valid data creates a categories" do
      valid_attrs = %{title: "some title"}

      assert {:ok, %Categories{} = categories} = Categorie.create_categories(valid_attrs)
      assert categories.title == "some title"
    end

    test "create_categories/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Categorie.create_categories(@invalid_attrs)
    end

    test "update_categories/2 with valid data updates the categories" do
      categories = categories_fixture()
      update_attrs = %{title: "some updated title"}

      assert {:ok, %Categories{} = categories} = Categorie.update_categories(categories, update_attrs)
      assert categories.title == "some updated title"
    end

    test "update_categories/2 with invalid data returns error changeset" do
      categories = categories_fixture()
      assert {:error, %Ecto.Changeset{}} = Categorie.update_categories(categories, @invalid_attrs)
      assert categories == Categorie.get_categories!(categories.id)
    end

    test "delete_categories/1 deletes the categories" do
      categories = categories_fixture()
      assert {:ok, %Categories{}} = Categorie.delete_categories(categories)
      assert_raise Ecto.NoResultsError, fn -> Categorie.get_categories!(categories.id) end
    end

    test "change_categories/1 returns a categories changeset" do
      categories = categories_fixture()
      assert %Ecto.Changeset{} = Categorie.change_categories(categories)
    end
  end
end
