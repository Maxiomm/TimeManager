defmodule TimemanagerWeb.UsersJSON do
  alias Timemanager.User.Users

  @doc """
  Renders a list of users.
  """
  def index(%{users: users}) do
    %{data: for(users <- users, do: data(users))}
  end

  @doc """
  Renders a single users.
  """
  def show(%{users: users}) do
    %{data: data(users)}
  end

  def showJwt(%{users: users, token: token}) do
    %{data: data(users), token: token}
  end

  def showJwtToken(%{users: users, token: token, jwt_token: jwt_token}) do
    %{data: data(users), token: token, jwt_token: jwt_token}
  end


  # Fonction pour formatter un utilisateur
  defp data(%Users{} = users) do
    %{
      id: users.id,
      username: users.username,
      email: users.email,
      status: users.status
    }
  end

  # Ajout d'une clause pour gérer les maps
  defp data(%{id: id, username: username, email: email, status: status}) do
    %{
      id: id,
      username: username,
      email: email,
      status: status
    }
  end
end
