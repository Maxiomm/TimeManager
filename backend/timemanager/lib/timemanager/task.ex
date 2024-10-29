defmodule Timemanager.Task do
  @moduledoc """
  The Task context.
  """

  import Ecto.Query, warn: false
  alias Timemanager.Repo

  alias Timemanager.Task.Tasks

  @doc """
  Returns the list of tasks.

  ## Examples

      iex> list_tasks()
      [%Tasks{}, ...]

  """
  def list_tasks do
    Repo.all(Tasks)
  end

  @doc """
  Gets a single tasks.

  Raises `Ecto.NoResultsError` if the Tasks does not exist.

  ## Examples

      iex> get_tasks!(123)
      %Tasks{}

      iex> get_tasks!(456)
      ** (Ecto.NoResultsError)

  """
  def get_tasks(id), do: Repo.get(Tasks, id)

  # GET a task by the id which links it to a user
  def findTaskByUserID(userID), do:
    from(u in Tasks,
      where: u.user_id == ^userID
    )
    |> Repo.all()


  # GET a task by the id which links it to a category
  def findTaskByCategorieID(categories_id), do:
    from(u in Tasks,
      where: u.category_id == ^categories_id
    )
    |> Repo.all()


  # GET a task by the id which links it to a user, the id which links it to a category
  def findTaskByUserIDAndCategoriesID(userID, categories_id), do:
    from(u in Tasks,
      where: u.user_id == ^userID and u.category_id == ^categories_id
    )
    |> Repo.all()

  @doc """
  Creates a tasks.

  ## Examples

      iex> create_tasks(%{field: value})
      {:ok, %Tasks{}}

      iex> create_tasks(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_tasks(tasks_params) do
    %Tasks{}
    |> Tasks.changeset(tasks_params)
    |> Repo.insert()
  end

  @doc """
  Updates a tasks.

  ## Examples

      iex> update_tasks(tasks, %{field: new_value})
      {:ok, %Tasks{}}

      iex> update_tasks(tasks, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_tasks(%Tasks{} = tasks, attrs) do
    IO.inspect(attrs)
    tasks
    |> Tasks.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a tasks.

  ## Examples

      iex> delete_tasks(tasks)
      {:ok, %Tasks{}}

      iex> delete_tasks(tasks)
      {:error, %Ecto.Changeset{}}

  """
  def delete_tasks(%Tasks{} = tasks) do
    Repo.delete(tasks)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking tasks changes.

  ## Examples

      iex> change_tasks(tasks)
      %Ecto.Changeset{data: %Tasks{}}

  """
  def change_tasks(%Tasks{} = tasks, attrs \\ %{}) do
    Tasks.changeset(tasks, attrs)
  end
end
