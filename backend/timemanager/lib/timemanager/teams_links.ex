defmodule Timemanager.TeamsLinks do
  @moduledoc """
  The TeamsLinks context.
  """

  import Ecto.Query, warn: false
  alias Timemanager.Repo

  alias Timemanager.TeamsLinks.TeamLink

  @doc """
  Returns the list of teamlink.

  ## Examples

      iex> list_teamlink()
      [%TeamLink{}, ...]

  """
  def list_teamlink do
    Repo.all(TeamLink)
  end

  @doc """
  Gets a single team_link.

  Raises `Ecto.NoResultsError` if the Team link does not exist.

  ## Examples

      iex> get_team_link!(123)
      %TeamLink{}

      iex> get_team_link!(456)
      ** (Ecto.NoResultsError)

  """
  def get_team_link(id), do: Repo.get(TeamLink, id)

  def get_team_link_by_id_user(user_id), do:
    from(u in TeamLink,
      where: u.user_id == ^user_id
    )
    |> Repo.all()

  def get_team_link_by_id_team(team_id), do:
    from(u in TeamLink,
      where: u.team_id == ^team_id
    )
    |> Repo.all()

  @doc """
  Creates a team_link.

  ## Examples

      iex> create_team_link(%{field: value})
      {:ok, %TeamLink{}}

      iex> create_team_link(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_team_link(attrs \\ %{}) do
    %TeamLink{}
    |> TeamLink.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a team_link.

  ## Examples

      iex> update_team_link(team_link, %{field: new_value})
      {:ok, %TeamLink{}}

      iex> update_team_link(team_link, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_team_link(%TeamLink{} = team_link, attrs) do
    team_link
    |> TeamLink.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a team_link.

  ## Examples

      iex> delete_team_link(team_link)
      {:ok, %TeamLink{}}

      iex> delete_team_link(team_link)
      {:error, %Ecto.Changeset{}}

  """
  def delete_team_link(%TeamLink{} = team_link) do
    Repo.delete(team_link)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking team_link changes.

  ## Examples

      iex> change_team_link(team_link)
      %Ecto.Changeset{data: %TeamLink{}}

  """
  def change_team_link(%TeamLink{} = team_link, attrs \\ %{}) do
    TeamLink.changeset(team_link, attrs)
  end
end
