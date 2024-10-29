defmodule Timemanager.WorkingTimeTest do
  use Timemanager.DataCase

  alias Timemanager.WorkingTime

  describe "workingtime" do
    alias Timemanager.WorkingTime.Working

    import Timemanager.WorkingTimeFixtures

    @invalid_attrs %{start: nil, end: nil}

    test "list_workingtime/0 returns all workingtime" do
      working = working_fixture()
      assert WorkingTime.list_workingtime() == [working]
    end

    test "get_working!/1 returns the working with given id" do
      working = working_fixture()
      assert WorkingTime.get_working!(working.id) == working
    end

    test "create_working/1 with valid data creates a working" do
      valid_attrs = %{start: ~U[2024-10-06 13:58:00Z], end: ~U[2024-10-06 13:58:00Z]}

      assert {:ok, %Working{} = working} = WorkingTime.create_working(valid_attrs)
      assert working.start == ~U[2024-10-06 13:58:00Z]
      assert working.end == ~U[2024-10-06 13:58:00Z]
    end

    test "create_working/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = WorkingTime.create_working(@invalid_attrs)
    end

    test "update_working/2 with valid data updates the working" do
      working = working_fixture()
      update_attrs = %{start: ~U[2024-10-07 13:58:00Z], end: ~U[2024-10-07 13:58:00Z]}

      assert {:ok, %Working{} = working} = WorkingTime.update_working(working, update_attrs)
      assert working.start == ~U[2024-10-07 13:58:00Z]
      assert working.end == ~U[2024-10-07 13:58:00Z]
    end

    test "update_working/2 with invalid data returns error changeset" do
      working = working_fixture()
      assert {:error, %Ecto.Changeset{}} = WorkingTime.update_working(working, @invalid_attrs)
      assert working == WorkingTime.get_working!(working.id)
    end

    test "delete_working/1 deletes the working" do
      working = working_fixture()
      assert {:ok, %Working{}} = WorkingTime.delete_working(working)
      assert_raise Ecto.NoResultsError, fn -> WorkingTime.get_working!(working.id) end
    end

    test "change_working/1 returns a working changeset" do
      working = working_fixture()
      assert %Ecto.Changeset{} = WorkingTime.change_working(working)
    end
  end

  describe "workingtime" do
    alias Timemanager.WorkingTime.Workingtime

    import Timemanager.WorkingTimeFixtures

    @invalid_attrs %{start: nil, end: nil}

    test "list_workingtime/0 returns all workingtime" do
      workingtime = workingtime_fixture()
      assert WorkingTime.list_workingtime() == [workingtime]
    end

    test "get_workingtime!/1 returns the workingtime with given id" do
      workingtime = workingtime_fixture()
      assert WorkingTime.get_workingtime!(workingtime.id) == workingtime
    end

    test "create_workingtime/1 with valid data creates a workingtime" do
      valid_attrs = %{start: ~U[2024-10-06 13:59:00Z], end: ~U[2024-10-06 13:59:00Z]}

      assert {:ok, %Workingtime{} = workingtime} = WorkingTime.create_workingtime(valid_attrs)
      assert workingtime.start == ~U[2024-10-06 13:59:00Z]
      assert workingtime.end == ~U[2024-10-06 13:59:00Z]
    end

    test "create_workingtime/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = WorkingTime.create_workingtime(@invalid_attrs)
    end

    test "update_workingtime/2 with valid data updates the workingtime" do
      workingtime = workingtime_fixture()
      update_attrs = %{start: ~U[2024-10-07 13:59:00Z], end: ~U[2024-10-07 13:59:00Z]}

      assert {:ok, %Workingtime{} = workingtime} = WorkingTime.update_workingtime(workingtime, update_attrs)
      assert workingtime.start == ~U[2024-10-07 13:59:00Z]
      assert workingtime.end == ~U[2024-10-07 13:59:00Z]
    end

    test "update_workingtime/2 with invalid data returns error changeset" do
      workingtime = workingtime_fixture()
      assert {:error, %Ecto.Changeset{}} = WorkingTime.update_workingtime(workingtime, @invalid_attrs)
      assert workingtime == WorkingTime.get_workingtime!(workingtime.id)
    end

    test "delete_workingtime/1 deletes the workingtime" do
      workingtime = workingtime_fixture()
      assert {:ok, %Workingtime{}} = WorkingTime.delete_workingtime(workingtime)
      assert_raise Ecto.NoResultsError, fn -> WorkingTime.get_workingtime!(workingtime.id) end
    end

    test "change_workingtime/1 returns a workingtime changeset" do
      workingtime = workingtime_fixture()
      assert %Ecto.Changeset{} = WorkingTime.change_workingtime(workingtime)
    end
  end
end
