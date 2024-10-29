defmodule TimemanagerWeb.Plugs.RolePlug do

  import Plug.Conn
  import Phoenix.Controller

  use Plug.Builder

#  @spec init(any) :: any

  def init(opts), do: opts

  @spec call(Plug.Conn.t(), any) :: Plug.Conn.t()
  def call(conn, opts) do
    role_needed=opts[:status]
    mobile = get_req_header(conn, "y-custom-header")

    if mobile != [] do
      jwt = get_req_header(conn, "x-custom-header")
      jwt_value = List.first(jwt)

      case jwt_value do
        nil ->
          conn
          |> put_status(:unauthorized)
          |> json(%{error: "JWT missing or invalid"})
          |> halt()

        _ ->
          checkjwt(conn, jwt_value, role_needed)
          conn
      end
    else
      jwt = conn.cookies["jwt"]
      case jwt do
        nil ->
          conn
          |> put_status(:unauthorized)
          |> json(%{error: "JWT missing or invalid"})
          |> halt()

        _ ->
          checkjwt(conn, jwt, role_needed)
          conn
      end
    end
  end

  defp checkjwt(conn, jwt, role_needed) do
    case jwt do
      nil ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "JWT missing or invalid"})
        |> halt()

      _ ->
        case Timemanager.Token.verify_and_validate(jwt) do
          {:ok, token} ->
            id_user = Map.get(token, "id")

            case Timemanager.User.get_users(id_user) do
              nil ->
                conn
                # Make a 404 status
                |> put_status(:not_found)
                  # Create a json message
                |> json(%{error: "User not found"})
                |> halt()

              %Timemanager.User.Users{status: role_user} ->
                level_access = %{
                  employee: 1,
                  manager: 2,
                  general_manager: 3
                }

                role_user_atom = String.to_existing_atom(String.replace(role_user, " ", "_"))
                role_needed_atom = String.to_existing_atom(String.replace(role_needed, " ", "_"))

                level_access_role_user = Map.get(level_access, role_user_atom)
                level_access_role_needed = Map.get(level_access, role_needed_atom)


                if(level_access_role_user >= level_access_role_needed)do
                  conn
                else
                  conn
                  # Make a 404 status
                  |> put_status(:bad_request)
                    # Create a json message
                  |> json(%{error: "Not authorized"})
                  |> halt()
                end
            end
          _ ->
            conn
            # Make a 404 status
            |> put_status(:bad_request)
              # Create a json message
            |> json(%{error: "error"})
            |> halt()
        end
    end
  end


  def call(conn, opts) do
  end
end
