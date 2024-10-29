defmodule Timemanager.ClockTest do
  use Timemanager.DataCase

  alias Timemanager.Clock

  describe "clocks" do
    alias Timemanager.Clock.Clocks

    import Timemanager.ClockFixtures

    @invalid_attrs %{status: nil, title: nil}

    test "list_clocks/0 returns all clocks" do
      clocks = clocks_fixture()
      assert Clock.list_clocks() == [clocks]
    end

    test "get_clocks!/1 returns the clocks with given id" do
      clocks = clocks_fixture()
      assert Clock.get_clocks!(clocks.id) == clocks
    end

    test "create_clocks/1 with valid data creates a clocks" do
      valid_attrs = %{status: "some status", title: "some title"}

      assert {:ok, %Clocks{} = clocks} = Clock.create_clocks(valid_attrs)
      assert clocks.status == "some status"
      assert clocks.title == "some title"
    end

    test "create_clocks/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Clock.create_clocks(@invalid_attrs)
    end

    test "update_clocks/2 with valid data updates the clocks" do
      clocks = clocks_fixture()
      update_attrs = %{status: "some updated status", title: "some updated title"}

      assert {:ok, %Clocks{} = clocks} = Clock.update_clocks(clocks, update_attrs)
      assert clocks.status == "some updated status"
      assert clocks.title == "some updated title"
    end

    test "update_clocks/2 with invalid data returns error changeset" do
      clocks = clocks_fixture()
      assert {:error, %Ecto.Changeset{}} = Clock.update_clocks(clocks, @invalid_attrs)
      assert clocks == Clock.get_clocks!(clocks.id)
    end

    test "delete_clocks/1 deletes the clocks" do
      clocks = clocks_fixture()
      assert {:ok, %Clocks{}} = Clock.delete_clocks(clocks)
      assert_raise Ecto.NoResultsError, fn -> Clock.get_clocks!(clocks.id) end
    end

    test "change_clocks/1 returns a clocks changeset" do
      clocks = clocks_fixture()
      assert %Ecto.Changeset{} = Clock.change_clocks(clocks)
    end
  end
end
