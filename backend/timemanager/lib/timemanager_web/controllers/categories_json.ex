defmodule TimemanagerWeb.CategoriesJSON do
  alias Timemanager.Categorie.Categories

  @doc """
  Renders a list of categories.
  """
  def index(%{categories: categories}) do
    %{data: for(categories <- categories, do: data(categories))}
  end

  @doc """
  Renders a single categories.
  """
  def show(%{categories: categories}) do
    %{data: data(categories)}
  end

  defp data(%Categories{} = categories) do
    %{
      id: categories.id,
      title: categories.title,
      color: categories.color
    }
  end

  # Ajout d'une clause pour gérer les maps
  defp data(%{id: id, title: title, color: color}) do
    %{
      id: id,
      title: title,
      color: color
    }
  end
end
