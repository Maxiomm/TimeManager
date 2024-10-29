defmodule Timemanager.User.Users do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :username, :string
    field :email, :string
    field :status, :string
    field :mdp, :string
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email, :status, :mdp])
    |> validate_format(:email, ~r/^[\w\.]+@[a-zA-Z0-9-]+\.[a-zA-Z]{1,}$/, message: "l'email doit avoir le format suivant un 'X@X.X'")
    |> validate_required([:username, :email, :status, :mdp])
    |> unique_constraint(:email, name: :unique_email)
  end
end
