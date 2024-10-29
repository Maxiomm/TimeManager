defmodule Timemanager.Categorie.Categories do
  use Ecto.Schema
  import Ecto.Changeset

  schema "categories" do
    field :title, :string
    field :color, :string

  end

  @doc false
  def changeset(categories, attrs) do
    categories
    |> cast(attrs, [:title, :color])
    |> validate_required([:title, :color])
  end
end
