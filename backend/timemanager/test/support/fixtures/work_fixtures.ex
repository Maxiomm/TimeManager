defmodule Timemanager.WorkFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Timemanager.Work` context.
  """

  @doc """
  Generate a working_time.
  """
  def working_time_fixture(attrs \\ %{}) do
    {:ok, working_time} =
      attrs
      |> Enum.into(%{
        end: ~U[2024-10-06 13:56:00Z],
        start: ~U[2024-10-06 13:56:00Z]
      })
      |> Timemanager.Work.create_working_time()

    working_time
  end
end
