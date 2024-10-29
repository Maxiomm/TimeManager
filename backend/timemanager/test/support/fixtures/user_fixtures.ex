defmodule Timemanager.UserFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Timemanager.User` context.
  """

  @doc """
  Generate a users.
  """
  def users_fixture(attrs \\ %{}) do
    {:ok, users} =
      attrs
      |> Enum.into(%{
        email: "some email",
        username: "some username"
      })
      |> Timemanager.User.create_users()

    users
  end
end
