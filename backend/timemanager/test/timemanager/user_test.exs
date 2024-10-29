defmodule Timemanager.UserTest do
  use Timemanager.DataCase

  alias Timemanager.User

  describe "users" do
    alias Timemanager.User.Users

    import Timemanager.UserFixtures

    @invalid_attrs %{username: nil, email: nil}

    test "list_users/0 returns all users" do
      users = users_fixture()
      assert User.list_users() == [users]
    end

    test "get_users!/1 returns the users with given id" do
      users = users_fixture()
      assert User.get_users!(users.id) == users
    end

    test "create_users/1 with valid data creates a users" do
      valid_attrs = %{username: "some username", email: "some email"}

      assert {:ok, %Users{} = users} = User.create_users(valid_attrs)
      assert users.username == "some username"
      assert users.email == "some email"
    end

    test "create_users/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = User.create_users(@invalid_attrs)
    end

    test "update_users/2 with valid data updates the users" do
      users = users_fixture()
      update_attrs = %{username: "some updated username", email: "some updated email"}

      assert {:ok, %Users{} = users} = User.update_users(users, update_attrs)
      assert users.username == "some updated username"
      assert users.email == "some updated email"
    end

    test "update_users/2 with invalid data returns error changeset" do
      users = users_fixture()
      assert {:error, %Ecto.Changeset{}} = User.update_users(users, @invalid_attrs)
      assert users == User.get_users!(users.id)
    end

    test "delete_users/1 deletes the users" do
      users = users_fixture()
      assert {:ok, %Users{}} = User.delete_users(users)
      assert_raise Ecto.NoResultsError, fn -> User.get_users!(users.id) end
    end

    test "change_users/1 returns a users changeset" do
      users = users_fixture()
      assert %Ecto.Changeset{} = User.change_users(users)
    end
  end
end
