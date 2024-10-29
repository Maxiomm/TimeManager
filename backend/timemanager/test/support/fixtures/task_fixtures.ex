defmodule Timemanager.TaskFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Timemanager.Task` context.
  """

  @doc """
  Generate a tasks.
  """
  def tasks_fixture(attrs \\ %{}) do
    {:ok, tasks} =
      attrs
      |> Enum.into(%{
        end: ~U[2024-10-09 14:03:00Z],
        start: ~U[2024-10-09 14:03:00Z],
        title: "some title"
      })
      |> Timemanager.Task.create_tasks()

    tasks
  end
end
