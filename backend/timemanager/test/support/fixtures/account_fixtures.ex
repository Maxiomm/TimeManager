defmodule Timemanager.AccountFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Timemanager.Account` context.
  """

  @doc """
  Generate a clock.
  """
  def clock_fixture(attrs \\ %{}) do
    {:ok, clock} =
      attrs
      |> Enum.into(%{
        status: true,
        title: "some title"
      })
      |> Timemanager.Account.create_clock()

    clock
  end
end
