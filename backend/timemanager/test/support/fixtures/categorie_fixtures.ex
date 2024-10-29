defmodule Timemanager.CategorieFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Timemanager.Categorie` context.
  """

  @doc """
  Generate a categories.
  """
  def categories_fixture(attrs \\ %{}) do
    {:ok, categories} =
      attrs
      |> Enum.into(%{
        title: "some title"
      })
      |> Timemanager.Categorie.create_categories()

    categories
  end
end
