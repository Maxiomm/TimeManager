defmodule Timemanager.Task.Tasks do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tasks" do
    field :title, :string
    field :start, :utc_datetime
    field :end, :utc_datetime
    belongs_to :category, Timemanager.Category, foreign_key: :category_id
    belongs_to :user, Timemanager.User, foreign_key: :user_id
  end

  @doc false
  def changeset(tasks, attrs) do
    tasks
    |> cast(attrs, [:title, :start, :end, :category_id, :user_id])
    |> validate_required([:title, :start, :end])
    |> foreign_key_constraint(:category_id)
    |> foreign_key_constraint(:user_id)
  end
end
