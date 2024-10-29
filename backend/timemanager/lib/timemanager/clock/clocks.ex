defmodule Timemanager.Clock.Clocks do
  use Ecto.Schema
  import Ecto.Changeset

  schema "clocks" do
    field :status, :boolean
    field :time, :utc_datetime
    belongs_to :user, Timemanager.User

  end

  @doc false
  def changeset(clocks, attrs) do
    clocks
    |> cast(attrs, [:status, :time, :user_id])
    |> validate_required([ :status, :time, :user_id])
  end
end
