defmodule Timemanager.WorkingTimeFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Timemanager.WorkingTime` context.
  """

  @doc """
  Generate a working.
  """
  def working_fixture(attrs \\ %{}) do
    {:ok, working} =
      attrs
      |> Enum.into(%{
        end: ~U[2024-10-06 13:58:00Z],
        start: ~U[2024-10-06 13:58:00Z]
      })
      |> Timemanager.WorkingTime.create_working()

    working
  end

  @doc """
  Generate a workingtime.
  """
  def workingtime_fixture(attrs \\ %{}) do
    {:ok, workingtime} =
      attrs
      |> Enum.into(%{
        end: ~U[2024-10-06 13:59:00Z],
        start: ~U[2024-10-06 13:59:00Z]
      })
      |> Timemanager.WorkingTime.create_workingtime()

    workingtime
  end
end
