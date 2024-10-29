defmodule Timemanager.TaskTest do
  use Timemanager.DataCase

  alias Timemanager.Task

  describe "tasks" do
    alias Timemanager.Task.Tasks

    import Timemanager.TaskFixtures

    @invalid_attrs %{start: nil, title: nil, end: nil}

    test "list_tasks/0 returns all tasks" do
      tasks = tasks_fixture()
      assert Task.list_tasks() == [tasks]
    end

    test "get_tasks!/1 returns the tasks with given id" do
      tasks = tasks_fixture()
      assert Task.get_tasks!(tasks.id) == tasks
    end

    test "create_tasks/1 with valid data creates a tasks" do
      valid_attrs = %{start: ~U[2024-10-09 14:03:00Z], title: "some title", end: ~U[2024-10-09 14:03:00Z]}

      assert {:ok, %Tasks{} = tasks} = Task.create_tasks(valid_attrs)
      assert tasks.start == ~U[2024-10-09 14:03:00Z]
      assert tasks.title == "some title"
      assert tasks.end == ~U[2024-10-09 14:03:00Z]
    end

    test "create_tasks/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Task.create_tasks(@invalid_attrs)
    end

    test "update_tasks/2 with valid data updates the tasks" do
      tasks = tasks_fixture()
      update_attrs = %{start: ~U[2024-10-10 14:03:00Z], title: "some updated title", end: ~U[2024-10-10 14:03:00Z]}

      assert {:ok, %Tasks{} = tasks} = Task.update_tasks(tasks, update_attrs)
      assert tasks.start == ~U[2024-10-10 14:03:00Z]
      assert tasks.title == "some updated title"
      assert tasks.end == ~U[2024-10-10 14:03:00Z]
    end

    test "update_tasks/2 with invalid data returns error changeset" do
      tasks = tasks_fixture()
      assert {:error, %Ecto.Changeset{}} = Task.update_tasks(tasks, @invalid_attrs)
      assert tasks == Task.get_tasks!(tasks.id)
    end

    test "delete_tasks/1 deletes the tasks" do
      tasks = tasks_fixture()
      assert {:ok, %Tasks{}} = Task.delete_tasks(tasks)
      assert_raise Ecto.NoResultsError, fn -> Task.get_tasks!(tasks.id) end
    end

    test "change_tasks/1 returns a tasks changeset" do
      tasks = tasks_fixture()
      assert %Ecto.Changeset{} = Task.change_tasks(tasks)
    end
  end
end
