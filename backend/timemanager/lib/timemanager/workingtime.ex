defmodule Timemanager.Workingtime do
  @moduledoc """
  The Workingtime context.
  """

  import Ecto.Query, warn: false
  alias Timemanager.Repo

  alias Timemanager.Workingtime.WorkingTime

  @doc """
  Returns the list of workingtime.

  ## Examples

      iex> list_workingtime()
      [%WorkingTime{}, ...]

  """
  def list_workingtime do
    Repo.all(WorkingTime)
  end

  @doc """
  Gets a single working_time.

  Raises `Ecto.NoResultsError` if the Working time does not exist.

  ## Examples

      iex> get_working_time!(123)
      %WorkingTime{}

      iex> get_working_time!(456)
      ** (Ecto.NoResultsError)

  """
  # Function to get a workingtime by his id
  def get_working_time(id), do: Repo.get(WorkingTime, id)

  # Function to get a workingtime by the id which links it to a user and his id
  def get_workingtime_by_id_user(user_id, id), do:
    from(u in WorkingTime,
      where: u.id == ^id and u.user_id == ^user_id
    )
    |> Repo.one()

  # Function to get all workingtimes by the id which links it to a user
  def get_workingtime_by_user(user_id), do:
    from(u in WorkingTime,
      where: u.user_id == ^user_id
    )
    |> Repo.all()

  # Function to get a workingtime by the id which links it to a user, his start field and end field
  def get_workingtime_by_start_end(user_id, startWorktimer, endWorktimer), do:
    from(u in WorkingTime,
      where: u.user_id == ^user_id and u.start == ^startWorktimer and u.end == ^endWorktimer
    )
    |> Repo.all()

  # Function to get a workingtime by the id which links it to a user and a empty end field
  def get_workingtime_by_end(user_id), do:
    from(u in WorkingTime,
      where: u.user_id == ^user_id and is_nil(u.end)
    )
    |> Repo.one()
  @doc """
  Creates a working_time.

  ## Examples

      iex> create_working_time(%{field: value})
      {:ok, %WorkingTime{}}

      iex> create_working_time(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  # Function to create a workingtime
  def create_working_time(user_id, start_str, end_str, isworking) do
    params = %{
      "start" => start_str,
      "end" => end_str,
      "isworking" => isworking,
      "user_id" => user_id
    }


    %WorkingTime{}
    |> WorkingTime.changeset(params)
    |> Repo.insert()
  end

  @doc """
  Updates a working_time.

  ## Examples

      iex> update_working_time(working_time, %{field: new_value})
      {:ok, %WorkingTime{}}

      iex> update_working_time(working_time, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  # Function to update a workingtime
  def update_working_time(%WorkingTime{} = working_time, attrs) do
    working_time
    |> WorkingTime.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a working_time.

  ## Examples

      iex> delete_working_time(working_time)
      {:ok, %WorkingTime{}}

      iex> delete_working_time(working_time)
      {:error, %Ecto.Changeset{}}

  """
  # Function to delete a workingtime
  def delete_working_time(%WorkingTime{} = working_time) do
    Repo.delete(working_time)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking working_time changes.

  ## Examples

      iex> change_working_time(working_time)
      %Ecto.Changeset{data: %WorkingTime{}}

  """
  def change_working_time(%WorkingTime{} = working_time, attrs \\ %{}) do
    WorkingTime.changeset(working_time, attrs)
  end
end
