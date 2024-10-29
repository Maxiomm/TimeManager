defmodule Timemanager.WorkingtimeFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Timemanager.Workingtime` context.
  """

  @doc """
  Generate a working_time.
  """
  def working_time_fixture(attrs \\ %{}) do
    {:ok, working_time} =
      attrs
      |> Enum.into(%{
        end: ~U[2024-10-06 14:06:00Z],
        start: ~U[2024-10-06 14:06:00Z]
      })
      |> Timemanager.Workingtime.create_working_time()

    working_time
  end

  @doc """
  Generate a working_time.
  """
  def working_time_fixture(attrs \\ %{}) do
    {:ok, working_time} =
      attrs
      |> Enum.into(%{
        end: ~U[2024-10-06 14:11:00Z],
        start: ~U[2024-10-06 14:11:00Z]
      })
      |> Timemanager.Workingtime.create_working_time()

    working_time
  end

  @doc """
  Generate a working_time.
  """
  def working_time_fixture(attrs \\ %{}) do
    {:ok, working_time} =
      attrs
      |> Enum.into(%{
        end: ~U[2024-10-06 14:20:00Z],
        start: ~U[2024-10-06 14:20:00Z]
      })
      |> Timemanager.Workingtime.create_working_time()

    working_time
  end

  @doc """
  Generate a working_time.
  """
  def working_time_fixture(attrs \\ %{}) do
    {:ok, working_time} =
      attrs
      |> Enum.into(%{
        end: ~U[2024-10-06 14:36:00Z],
        start: ~U[2024-10-06 14:36:00Z]
      })
      |> Timemanager.Workingtime.create_working_time()

    working_time
  end
end
