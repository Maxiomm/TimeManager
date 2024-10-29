defmodule Timemanager.Clock do
  @moduledoc """
  The Clock context.
  """

  import Ecto.Query, warn: false
  alias Timemanager.Repo

  alias Timemanager.Clock.Clocks

  @doc """
  Returns the list of clocks.

  ## Examples

      iex> list_clocks()
      [%Clocks{}, ...]

  """
  def list_clocks do
    Repo.all(Clocks)
  end

  @doc """
  Gets a single clocks.

  Raises `Ecto.NoResultsError` if the Clocks does not exist.

  ## Examples

      iex> get_clocks!(123)
      %Clocks{}

      iex> get_clocks!(456)
      ** (Ecto.NoResultsError)

  """

  #  Function get clock by user id
  def get_clocks_by_id_user(user_id), do:
    from(u in Clocks,
      where: u.user_id == ^user_id
    )
    |> Repo.all()

  @doc """
  Creates a clocks.

  ## Examples

      iex> create_clocks(%{field: value})
      {:ok, %Clocks{}}

      iex> create_clocks(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """

  #  Function create clocks
  def create_clocks(status, time, user_id) do
    params = %{
      "time" => time,
      "status" => status,
      "user_id" => user_id
    }


    %Clocks{}
    |> Clocks.changeset(params)
    |> Repo.insert()
  end
end
