defmodule Timemanager.Workingtime.WorkingTime do
  use Ecto.Schema
  import Ecto.Changeset

  schema "workingtime" do
    field :start, :utc_datetime
    field :end, :utc_datetime
    field :isworking, :boolean
    belongs_to :user, Timemanager.User

  end

  @doc false
  def changeset(working_time, attrs) do
    working_time
    |> cast(attrs, [:start, :end, :isworking, :user_id])
    |> validate_required([:start, :isworking, :user_id])
    |> foreign_key_constraint(:user_id)
  end
end
