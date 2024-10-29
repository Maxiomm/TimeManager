defmodule Timemanager.ClockFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Timemanager.Clock` context.
  """

  @doc """
  Generate a clocks.
  """
  def clocks_fixture(attrs \\ %{}) do
    {:ok, clocks} =
      attrs
      |> Enum.into(%{
        status: "some status",
        title: "some title"
      })
      |> Timemanager.Clock.create_clocks()

    clocks
  end
end
