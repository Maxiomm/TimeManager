defmodule Timemanager.User do
  @moduledoc """
  The User context.
  """

  import Ecto.Query, warn: false
  alias Timemanager.Repo

  alias Timemanager.User.Users

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%Users{}, ...]

  """
  def list_users do
    Repo.all(Users)
  end

  @doc """
  Gets a single users.

  Raises `Ecto.NoResultsError` if the Users does not exist.

  ## Examples

      iex> get_users!(123)
      %Users{}

      iex> get_users!(456)
      ** (Ecto.NoResultsError)

  """
  #  Function get user by id
  def get_users(id), do: Repo.get(Users, id)

  #  Function get user by email and username
  def get_user_by_email_and_username(email, username), do:
    from(u in Users,
      where: u.email == ^email and u.username == ^username
    )
    |> Repo.one()

  def findUserByEmail(email), do:
    from(u in Users,
      where: u.email == ^email
    )
    |> Repo.one()

  def findUserByTeam(team), do:
    from(u in Users,
      where: u.team_id == ^team
    )
    |> Repo.all()

  @doc """
  Creates a users.

  ## Examples

      iex> create_users(%{field: value})
      {:ok, %Users{}}

      iex> create_users(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  # Function to create a user
  def create_users(username, email, status, mdp) do
    params = %{
      "username" => username,
      "email" => email,
      "status" => status,
      "mdp" => mdp,
    }

    %Users{}
    |> Users.changeset(params)
    |> Repo.insert()
  end

  @doc """
  Updates a users.

  ## Examples

      iex> update_users(users, %{field: new_value})
      {:ok, %Users{}}

      iex> update_users(users, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  # Function to update a user
  def update_users(%Users{} = users, attrs) do
    users
    |> Users.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a users.

  ## Examples

      iex> delete_users(users)
      {:ok, %Users{}}

      iex> delete_users(users)
      {:error, %Ecto.Changeset{}}

  """
  # Function to delete a user
  def delete_users(%Users{} = users) do
    Repo.delete(users)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking users changes.

  ## Examples

      iex> change_users(users)
      %Ecto.Changeset{data: %Users{}}

  """
  def change_users(%Users{} = users, attrs \\ %{}) do
    Users.changeset(users, attrs)
  end
end
